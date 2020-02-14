# grpc-json-transcoder

The cloning of Google protobuf API repos (given below) is based on the [gRPC-JSON transcoder documentation](https://www.envoyproxy.io/docs/envoy/v1.9.0/configuration/http_filters/grpc_json_transcoder_filter) (these docs kinda suck). This is required because the proto file `helloworld.proto` has other proto dependencies by Google. Ideally, the build artifacts of these dependencies would be downloaded from a registry and linked with `helloworld.proto`, all through the build tool. For a gradle project, these built artifacts are available on the maven central registry. But for an npm project, we would require JS stubs in the form of npm packages, hosted on an npm registry, of which there is none for these packages (AFAIK). Hence, we clone the repositories where these proto dependencies live and we provide their paths to the `protoc` compiler. For the envoy yaml config in this project, the instructions are given in this [blog post](https://blog.jdriven.com/2018/11/transcoding-grpc-to-http-json-using-envoy/).

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
