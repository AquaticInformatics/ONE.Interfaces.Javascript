# == generate all javascript and typescript files ==
./generateTS.sh

# == echo location and target directory ==
echo "current directory: `pwd`"
echo "lib directory: ../lib"

# == prepare output directory ==
rm -rf ../lib/src
mkdir -p ../lib/src

# == move api-response protobuf files to lib directory ==
cp -p ./out/js/apiresponse.js ../lib/src/apiresponse.js
cp -p ./out/ts/apiresponse.d.ts ../lib/src/apiresponse.d.ts

# == pull lib dependencies and publish ==
cd ../lib
npm install
npm publish --access public
