# == generate all javascript and typescript files ==
./generateTS.sh

# == echo location and target directory ==
echo "current directory: `pwd`"
echo "lib directory: ../lib"

# == prepare output directory ==
rm -rf ../lib/src
mkdir -p ../lib/src

# == move api-response protobuf files to lib directory ==
cp -p ./out/js/api_response.js ../lib/src/api_response.js
cp -p ./out/ts/api_response.d.ts ../lib/src/api_response.d.ts

# == configure @hach scope to point at Hach ProGet registry ==
npm config set @hach:registry https://pkgs.dev.azure.com/claros-devops/claros-npm/_packaging/claros-npm/npm/registry/

# == pull lib dependencies and publish ==
cd ../lib
npm install
npm publish