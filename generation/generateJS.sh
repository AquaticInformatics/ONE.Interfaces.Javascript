#!/bin/sh

# == echo location and target directory ==
echo "current directory: `pwd`"
echo "target directory: `pwd`/out/js"

# == prepare output directories ==
rm -rf ./out/js
mkdir -p ./out/js

# == pull dependencies ==
npm install

PROTOPATHS=`find ../claros.interfaces.protocolbuffers -type d -print | xargs -n 1 -I {} echo "-p {}" | xargs echo`

# == compile with protobufjs ==
for P in `find ../claros.interfaces.protocolbuffers/proto/claros -name "*.proto"`
do
	PROTO=`basename -s .proto ${P}`
	echo "=== ${P} :: (${PROTO})"

	node_modules/protobufjs/cli/bin/pbjs -t static-module -w commonjs ${PROTOPATHS} -o ./out/js/${PROTO}.js ${P}

done
