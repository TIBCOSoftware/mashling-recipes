# gRPC to REST
This recipe demonstrates receiving request from a gRPC client and routing to REST end point based on method names.

## Installation
* Install [Go](https://golang.org/)
* Install `grpc`
```bash
go get -u google.golang.org/grpc
```
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
cd mashling-recipes/recipes/grpc-to-rest-gateway
```
Create mashling gateway.
```bash
mashling-cli create -c grpc-to-rest-gateway.json -p petstore.proto -N -n grpc-rest-gateway-app
```

Copy created binary from grpc-rest-gateway-app folder to current.
```bash
cp ./grpc-rest-gateway-app/mashling-gateway* .
```

Rename mashling-gateway* to grpc-rest-gateway

## Testing
Start proxy gateway.
```bash
./grpc-rest-gateway -c grpc-to-rest-gateway.json
```
### #1 Testing PetById method
Run sample gRPC client.
```bash
go run main.go -client -port 9096 -method pet -param 2
```
Output can be seen as below.
```
res : pet:<id:2 name:"cat2" >
```
### #2 Testing UserByName method
Run sample gRPC client.
```bash
go run main.go -client -port 9096 -method user -param user1
```
Output can be seen as below.
```
res : user:<id:1 username:"user1" email:"email1@test.com" phone:"123-456-7890" >
```