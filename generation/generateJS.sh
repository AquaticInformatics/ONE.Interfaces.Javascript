#!/bin/sh

# == echo location and target directory ==
echo "current directory: `pwd`"
echo "target directory: `pwd`/out/js"

# == prepare output directories ==
rm -rf ./out/js
mkdir -p ./out/js

# == pull dependencies ==
npm install

PROTOPATHS=`find ../one.interfaces.protocolbuffers -type d -print | xargs -n 1 -I {} echo "-p {}" | xargs echo`

# == compile with protobufjs ==
for P in `find ../one.interfaces.protocolbuffers/proto/flat -name "*.proto"`
do
	PROTO=`basename -s .proto ${P}`
	echo "=== ${P} :: (${PROTO})"

	# Special handling for apiresponse to include all enum files
	if [ "$PROTO" = "apiresponse" ]; then
		echo "=== Including all enum files for apiresponse ==="
		ENUM_FILES=`find ../one.interfaces.protocolbuffers/proto/flat -name "enum_*.proto" | xargs echo`
		node_modules/protobufjs/cli/bin/pbjs -t static-module -w commonjs ${PROTOPATHS} -o ./out/js/${PROTO}.js ${P} ${ENUM_FILES}
	else
		node_modules/protobufjs/cli/bin/pbjs -t static-module -w commonjs ${PROTOPATHS} -o ./out/js/${PROTO}.js ${P}
	fi

done

# == post-process files to move enums to bottom ==
echo "=== Post-processing files to move enums to bottom ==="
node reorganize-enums.js
