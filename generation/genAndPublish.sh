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

# == configure @aqi scope to point at AQI ProGet registry ==
npm config set @aqi:registry https://pkgs.dev.azure.com/aqi-devops/23daa24c-9d36-459f-8fc3-3a4ffa9de92a/_packaging/aqi-npm/npm/registry/

# == pull lib dependencies and publish ==
cd ../lib
npm install
npm publish
