# grpc-json-transcoder

For gRPC-JSON transcoding, dependencies by Google such as `annotations.proto` are required to generate the protobuf descriptor set. This is based on the [gRPC-JSON transcoder documentation](https://www.envoyproxy.io/docs/envoy/v1.9.0/configuration/http_filters/grpc_json_transcoder_filter) (these docs kinda suck btw). These dependencies need to be pulled directly from their source code repositories, by specifying a repository url with a git tag or commit hash. Some package managers, such as Glide for Golang, provide an easy way to pull these dependencies without needing to manually clone their repositories. Gradle (Java) even provides [`"com.google.api.grpc:proto-google-common-protos"`](https://mvnrepository.com/artifact/com.google.api.grpc/proto-google-common-protos), removing the need to list out the dependencies' repositories ourselves.

The npm tool doesn't do any of this.

Hence, we clone the repositories where these proto dependencies live manually. Then we provide their paths to the `protoc` compiler.

The instructions for configuring the envoy yaml file are given in this [blog post](https://blog.jdriven.com/2018/11/transcoding-grpc-to-http-json-using-envoy/).

## Requirements

- node
- protoc
- docker

## Development

Clone the Google protobuf repositories

```sh
$ npm run clone:vendors
```

Generate the protobuf descriptor set

```sh
$ chmod +x descriptor-gen.sh
$ ./descriptor-gen.sh
```

Build the docker image. This image will contain the `envoy.yaml` configuraion and the `proto.pb` descriptor set, used for gRPC-JSON transcoding. Then spin up a container with the appropriate port mapping.

```sh
$ docker build . \
    -t grpc-json-transcoder:latest \
    -f ./envoy.Dockerfile
$ docker run -d \
    -p 8080:8080 \
    -p 9901:9901 \
    grpc-json-transcoder:latest
```

Run the Node gRPC server

```sh
$ npm run start:server
```

Using any http client, make calls to the envoy proxy, through the transcoding endpoints in `helloworld.proto`. These http calls will be mapped to gRPC service calls, and forwarded to the node gRPC server. That server's response will be mapped to an http response, and forwarded to the http client.

```sh
$ curl localhost:8080/say/foobar
{
 "message": "Hello, foobar!"
}
```

When changing any of the gRPC-JSON transcoding mappings in `helloworld.proto`, you'll have to delete the old proto descriptor set (`$ npm run clean:descriptor`), generate a new one, and rebuild the docker image.
