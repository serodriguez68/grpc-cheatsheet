PROTO_FOLDER_PATH="./"
PROTO_PLUGIN_PATH="protoc-gen-grpc-java-1.41.0-osx-x86_64.exe"
OUTPUT_DIR="./"
protoc --proto_path=$PROTO_FOLDER_PATH --plugin=protoc-gen-grpc-java=$PROTO_PLUGIN_PATH --grpc-java_out=$OUTPUT_DIR --java_out=$OUTPUT_DIR $PROTO_FOLDER_PATH/employee.proto