# gRPC to gRPC
This recipe demonstrates on receiving request from a gRPC client and routing to gRPC end point based on method names.

## Installation
* Download [protoc](https://github.com/google/protobuf/releases) binary and configure it in PATH
* Download and install [protoc-gen-go](https://github.com/golang/protobuf#installation)
* Download and install [mashling](https://github.com/TIBCOSoftware/mashling#using-go)

## Setup
Get the grpc to grpc gateway files
```bash
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/grpc-to-grpc-gateway
```
Generate support files from proto file
```bash
./mashling-cli grpc generate -p petstore.proto
```

Build sample client and server provided here
```bash
cd samplegrpcserver
go install ./...
cd ../samplegrpcclient
go install ./...
```

Build mashling gateway
```bash
cd $GOPATH/src/github.com/TIBCOSoftware/mashling
go run build.go build
```

Generated code is available in below path
```bash
cd $GOPATH/src/github.com/TIBCOSoftware/mashling/gen/grpc
```

## Testing
Run sample server on port 9000 and 9001 in different terminals
```bash
./samplegrpcserver -port 9000
./samplegrpcserver -port 9001
```

Go to grpc-to-grpc-gateway folder and run the mashling gateway
```bash
./mashling-gateway -c grpc-to-grpc-gateway.json
```

Run sample client to check the output
```bash
./samplegrpcclient -p 9096 -o 1 -i 2
```

-p --> PORT value<br>
-o --> 1 to invoke PetById method, 2 to invoke UserByName method<br>
-i --> if -o is set to 1 this will take id value<br>
-n --> if -o is set to 2 this will take name value<br>

## Removing generated support files
```bash
./mashling-cli grpc clean -p petstore.proto
```
-p --> proto file path<br>
-a --> bool flag to remove all the generated files