# gRPC to REST
This recipe demonstrates receiving request from a gRPC client and routing to REST end point based on method names.

## Installation
* Download the mashling-gateway binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)
* Download [protoc](https://github.com/google/protobuf/releases) binary for respective OS and update PATH environment variable to include protoc binary.
* Install `protoc-gen-go` library
```
go get -u github.com/golang/protobuf/protoc-gen-go
```

## Setup
```bash
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/grpc-to-rest-gateway
```

Build sample client(grpcClient.go) provided here
```bash
go install ./...
```

Create custom gateway binary by passing gateway json and proto file
```bash
./mashling-cli create -c grpc-to-rest-gateway.json -p petstore.proto -N
```

Generated support files available in below path
```bash
cd mashling-custom/src/github.com/TIBCOSoftware/mashling/gen/grpc
```

## Testing
Copy grpc-to-rest-gateway.json to `mashling-custom` folder, rename the mashling custom binary to mashling-gateway.<br>
Run the mashling-gateway binary with grpc-to-rest-gateway.json
```bash
./mashling-gateway -c grpc-to-rest-gateway.json
```

Run sample client to check the output

-p --> PORT value<br>
-o --> 1 to invoke PetById method, 2 to invoke UserByName method<br>
-i --> if -o is set to 1 this will take id value<br>
-n --> if -o is set to 2 this will take name value<br>

```bash
./grpc-to-rest-gateway -p 9096 -o 1 -i 2
```
