# gRPC to gRPC
This recipe demonstrates receiving request from a gRPC client and routing to gRPC server.

## Installation
* Install [Go](https://golang.org/)
* Install `protoc-gen-go` library
```bash
go get -u github.com/golang/protobuf/protoc-gen-go
```
* Download protoc-$VERSION-$PLATFORM.zip for respective OS from [here](https://github.com/google/protobuf/releases).<br>Extract the zip file get the `protoc` binary from bin folder and configure it in PATH.
* Download the Mashling-CLI Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)


## Setup
```bash
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/grpc-to-grpc-gateway
```

Place the Downloaded Mashling-CLI binary in grpc-to-grpc-gateway folder.

Build sample gRPC client and server provided here.
```bash
cd samplegRPCServer
go install ./...
cd ../samplegRPCClient
go install ./...
cd ..
```

Create mashling gateway custom binary.
```bash
./mashling-cli create -c grpc-to-grpc-gateway.json -p petstore.proto -N -n MygRPCGateway
```

Copy grpc-to-grpc-gateway.json to MygRPCGateway folder.
```bash
cp grpc-to-grpc-gateway.json ./MygRPCGateway
```

Go to MygRPCGateway folder rename mashling-gateway-$GOOS-$GOARCH.exe to mashling-gateway.exe

## Testing
Open one terminal run below command to start sample gRPC server on port 9000.
```bash
samplegRPCServer
```

Usage of sample gRPC Client:<br>
-port --> PORT value<br>
-option --> 1 to invoke PetById method, 2 to invoke UserByName method<br>
-id --> if -option is set to 1 this will take id value<br>
-name --> if -option is set to 2 this will take name value<br>

Open another terminal run sample gRPC client.
```bash
samplegrpcclient -port 9000 -option 1 -id 2
```

Output can be seen as below.
```
res : pet:<id:2 name:"cat2" >
```

Run below command to check user response.
```bash
samplegrpcclient -port 9000 -option 2 -name user2
```
Output can be seen as below.
```
res : user:<id:2 username:"user2" email:"email2" phone:"phone2" >
```

### Testing grpc to grpc gateway

Go to MygRPCGateway folder and run below command. Gateway server will start on port 9096.
```bash
./mashling-gateway -c grpc-to-grpc-gateway.json
```
Open another terminal run sample gRPC client.
```bash
samplegrpcclient -port 9096 -option 1 -id 4
```
Output can be seen as below.
```
res : pet:<id:4 name:"cat4" >
```

## Note
Support files generated can be found in path MygRPCGateway/src/github.com/TIBCOSoftware/mashling/gen/grpc