#!/bin/sh

# == js files are a prerequisite ==
./generateJS.sh

# == echo location and target directory ==
echo "current directory: `pwd`"
echo "source js directory: `pwd`out/js"
echo "target directory: `pwd`out/ts"
echo "lib directory: ../lib"

# == prepare output directory ==
rm -rf ./out/ts
mkdir -p ./out/ts

# == compile with protobufjs ==
for P in `find ./out/js -name "*.js"`
do PROTO=`basename -s .js ${P}`
echo "=== ${P} :: (${PROTO})"
node_modules/protobufjs/cli/bin/pbts  \
  -o ./out/ts/${PROTO}.d.ts \
  ${P}
done
