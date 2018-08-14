# gRPC to gRPC
This recipe is a proxy gateway for gRPC end points.

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
cd mashling-recipes/recipes/grpc-to-grpc-gateway
```
Create mashling gateway.
```bash
mashling-cli create -c grpc-to-grpc-gateway.json -p petstore.proto -N -n grpc-proxy-gateway-app
```

Copy created binary from grpc-proxy-gateway-app folder to current.
```bash
cp ./grpc-proxy-gateway-app/mashling-gateway* .
```
Rename mashling-gateway* to grpc-proxy-gateway.

## Testing
Start proxy gateway.
```bash
./grpc-proxy-gateway -c grpc-to-grpc-gateway.json
```

Start sample gRPC server.
```bash
go run main.go -server
```

### #1 Testing PetById method
Run sample gRPC client.
```bash
go run main.go -client -port 9096 -method pet -param 2
```
Now you should see logs in proxy gateway terminal and sample gRPC server terminal. Sample output in client terminal can be seen as below.
```
res : pet:<id:2 name:"cat2" >
```
### #2 Testing UserByName method
Run sample gRPC client.
```bash
go run main.go -client -port 9096 -method user -param user2
```
Output can be seen as below.
```
res : user:<id:2 username:"user2" email:"email2" phone:"phone2" >
```