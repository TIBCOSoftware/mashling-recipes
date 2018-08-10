# gRPC to gRPC
This recipe is a proxy gateway for gRPC end points.

## Installation
* Install [Go](https://golang.org/)
* Install `protoc-gen-go` library
```bash
go get github.com/golang/protobuf/protoc-gen-go
```
* Download protoc for your respective OS from [here](https://github.com/google/protobuf/releases).<br>Extract protoc-$VERSION-$PLATFORM.zip file get the `protoc` binary from bin folder and configure it in PATH.
* Install mashling
```bash
go get github.com/TIBCOSoftware/mashling/...
```
## Setup
```bash
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/grpc-to-grpc-gateway
```
Create mashling gateway.
```bash
mashling-cli create -c grpc-to-grpc-gateway.json -p petstore.proto -N -n grpc-proxy-gateway
```

Copy created binary from grpc-proxy-gateway folder.
```bash
cp /grpc-proxy-gateway/mashling-gateway* grpc-proxy-gateway.exe
```

## Testing
Open one terminal pointing to grpc-to-grpc-gateway and run below command to start proxy gateway
```bash
./grpc-proxy-gateway.exe -c grpc-to-grpc-gateway.json
```

Similarly open another terminal and run below command to start sample gRPC server on port 9000.
```bash
go run main.go -server
```
Similarly open another terminal run sample gRPC client.
```bash
go run main.go -client -port 9096 -method pet -param 2
```
Output can be seen as below.
```
res : pet:<id:2 name:"cat2" >
```

Run below command to check user response.
```bash
go run main.go -client -port 9096 -method user -param user2
```
Output can be seen as below.
```
res : user:<id:2 username:"user2" email:"email2" phone:"phone2" >
```