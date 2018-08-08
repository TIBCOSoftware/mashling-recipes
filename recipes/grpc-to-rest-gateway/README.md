# gRPC to REST
This recipe demonstrates on receiving request from a gRPC client and routing to REST end point based on method names.

## Installation
* Download [protoc](https://github.com/google/protobuf/releases) binary and configure it in PATH
* Download and install [protoc-gen-go](https://github.com/golang/protobuf#installation)
* Download and install [mashling](https://github.com/TIBCOSoftware/mashling#using-go)

## Setup
Get the grpc to rest gateway files
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
./mashling-cli create -c grpc-to-rest-gateway.json -p petstore.proto -N -n <APPNAME>
```

Generated support files available in below path
```bash
cd <PATH TO APPNAME>/src/github.com/TIBCOSoftware/mashling/gen/grpc
```

## Testing
Copy grpc-to-rest-gateway.json to `<APPNAME>` folder and run the `<CUSTOM BINARY>`.
```bash
./<CUSTOM BINARY> -c grpc-to-rest-gateway.json
```

Run sample client to check the output
```bash
./grpc-to-rest-gateway -p 9096 -o 1 -i 2
```

-p --> PORT value<br>
-o --> 1 to invoke PetById method, 2 to invoke UserByName method<br>
-i --> if -o is set to 1 this will take id value<br>
-n --> if -o is set to 2 this will take name value<br>