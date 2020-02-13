#!/bin/bash

GOOGLEAPIS_DIR=./googleapis
GOOGLEPROTOBUF_DIR=./protobuf/src

protoc proto/helloworld.proto \
    -I$GOOGLEAPIS_DIR -I$GOOGLEPROTOBUF_DIR -I. \
    --include_imports --include_source_info \
    --descriptor_set_out=proto.pb
