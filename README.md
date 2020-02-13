# grpc-json-transcoder

The cloning of Google protobuf API repos (given below) is based on the [gRPC-JSON transcoder documentation](https://www.envoyproxy.io/docs/envoy/v1.9.0/configuration/http_filters/grpc_json_transcoder_filter) (these docs kinda suck). This wouldn't be needed if this were a gradle project. For that, and for the envoy yaml config in this project, the instructions are given in this [blog post](https://blog.jdriven.com/2018/11/transcoding-grpc-to-http-json-using-envoy/).

## Requirements

- node
- protoc
- docker

## Setup

Clone the Google protobuf API repositories

```sh
$ git clone https://github.com/googleapis/googleapis
$ git clone https://github.com/protocolbuffers/protobuf
```

Generate the protobuf descriptor set

```sh
$ chmod +x descriptor-gen.sh
$ ./descriptor-gen.sh
```

Build the docker image and spin up a container

```sh
$ docker build . \
    -t json-transcoder/envoy \
    -f ./envoy.Dockerfile
$ docker run -d json-transcoder/envoy \
    -p 8080:8080 \
    -p 9901:9901
```
