#!/bin/sh

# == configure @hach scope and point at ProGet registry ==
npm config set @hach:registry http://components.fusion.hach.com/npm/FF-npm

# == js files are a prerequisite ==
./generateJS.sh

# == echo location and target directory ==
echo "current directory: `pwd`"
echo "source js directory: `pwd`out/js"
echo "target directory: `pwd`out/ts"
echo "lib directory: ../lib"

# == prepare output directories ==
rm -rf ./out/ts
mkdir -p ./out/ts
rm -rf ../lib/src
mkdir -p ../lib/src

# == compile with protobufjs ==
for P in `find ./out/js -name "*.js"`
do PROTO=`basename -s .js ${P}`
echo "=== ${P} :: (${PROTO})"
node_modules/protobufjs/cli/bin/pbts  \
  -o ./out/ts/${PROTO}.d.ts \
  ${P}
done

# == move api-response protobuf files to lib directory ==
cp -p ./out/js/api_response.js ../lib/src/api_response.js
cp -p ./out/ts/api_response.d.ts ../lib/src/api_response.d.ts

# == pull lib dependencies ==
cd ../lib
npm install
