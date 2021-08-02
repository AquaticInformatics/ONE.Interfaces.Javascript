#!/bin/sh

# == echo location and target directory ==
echo "current directory: `pwd`"
echo "target directory: `pwd`/out/js"

# == prepare output directories ==
rm -rf ./out/js
mkdir -p ./out/js

# == pull dependencies ==
npm install

# == compile with protobufjs ==
for P in `find ../claros.interfaces.protocolbuffers/proto/claros -name "*.proto"`
do PROTO=`basename -s .proto ${P}`
echo "=== ${P} :: (${PROTO})"
node_modules/protobufjs/cli/bin/pbjs -t static-module -w commonjs  \
  -p ../claros.interfaces.protocolbuffers/proto/claros \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/activity \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/activity/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/activity/enum \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/computation \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/configuration \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/core \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/enum \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/form \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/form/core \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/form/data \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/form/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/gis \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/library \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/notification \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/notification/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/notification/enum \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/recurrence \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/report \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/report/core \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/report/data \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/task \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/task/core \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/task/data \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/task/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/common/task/enum \
  -p ../claros.interfaces.protocolbuffers/proto/claros/enterprise \
  -p ../claros.interfaces.protocolbuffers/proto/claros/enterprise/core \
  -p ../claros.interfaces.protocolbuffers/proto/claros/enterprise/data \
  -p ../claros.interfaces.protocolbuffers/proto/claros/enterprise/enum \
  -p ../claros.interfaces.protocolbuffers/proto/claros/enterprise/report \
  -p ../claros.interfaces.protocolbuffers/proto/claros/enterprise/report/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/enterprise/report/enum \
  -p ../claros.interfaces.protocolbuffers/proto/claros/enterprise/twin \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/core \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/data \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/enum \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/event \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/event/data \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/lock \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/measurement \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/measurement/data \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/measurement/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/menu \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/setting \
  -p ../claros.interfaces.protocolbuffers/proto/claros/instrument/status \
  -p ../claros.interfaces.protocolbuffers/proto/claros/iot \
  -p ../claros.interfaces.protocolbuffers/proto/claros/iot/core \
  -p ../claros.interfaces.protocolbuffers/proto/claros/iot/registry \
  -p ../claros.interfaces.protocolbuffers/proto/claros/iot/registry/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/iot/registry/enum \
  -p ../claros.interfaces.protocolbuffers/proto/claros/operations \
  -p ../claros.interfaces.protocolbuffers/proto/claros/operations/spreadsheet \
  -p ../claros.interfaces.protocolbuffers/proto/claros/operations/spreadsheet/core \
  -p ../claros.interfaces.protocolbuffers/proto/claros/operations/spreadsheet/data \
  -p ../claros.interfaces.protocolbuffers/proto/claros/operations/spreadsheet/definition \
  -p ../claros.interfaces.protocolbuffers/proto/claros/operations/spreadsheet/enum \
  -o ./out/js/${PROTO}.js \
  ${P}
done
