#!/bin/bash

protoc proto/helloworld.proto \
    -I./vendor/googleapis \
    -I./vendor/protobuf/src \
    -I. \
    --include_imports --include_source_info \
    --descriptor_set_out=proto.pb
