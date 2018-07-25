
echo "[GRPC]: Building protobuff file for GO: ${pwd}/micro-minding-shared/proto/document.proto"
protoc -I micro-minding-shared/proto micro-minding-shared/proto/document.proto --go_out=plugins=grpc:micro-minding-grpc_gateway/_proto
