# REST to gRPC
This recipe demonstrates on receiving request from a Rest client and routing to gRPC server.

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
cd mashling-recipes/recipes/rest-to-grpc-gateway
```
Create mashling gateway.
```bash
mashling-cli create -c rest-to-grpc-gateway.json -p petstore.proto -N -n rest-grpc-gateway-app
```

Move created binary from rest-grpc-gateway-app folder to current.
```bash
cp ./rest-grpc-gateway-app/mashling-gateway* rest-grpc-gateway
```
Create grpc stub file for sample server.
```bash
mkdir -p $GOPATH/src/rest-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/rest-to-grpc-gateway/petstore/
```

## Testing
Start gateway.
```bash
./rest-grpc-gateway -c rest-to-grpc-gateway.json
```

Start sample gRPC server.
```bash
go run main.go -server
```

### #1 Testing PetById method with GET request
Sample GET request.
```curl
curl --request GET http://localhost:9096/petstore/PetById?id=2
```
Now you should see logs in gateway terminal and sample gRPC server terminal. Output in curl request terminal can be seen as below.
```json
{
 "pet": {
  "id": 2,
  "name": "cat2"
 }
}
```
### #2 Testing UserByName method with GET request
Sample GET request.
```curl
curl --request GET http://localhost:9096/petstore/UserByName?username=user2
```
Output can be seen as below.
```json
{
 "user": {
  "email": "email2",
  "id": 2,
  "phone": "phone2",
  "username": "user2"
 }
}
```
### #3 Testing PetPUT method with PUT request
Payload
```json
{
 "pet": {
  "id": 12,
  "name": "mycat12"
 }
}
```
Curl command
```curl
curl -X PUT "http://localhost:9096/petstore/PetPUT" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"pet": {"id": 12,"name": "mycat12"}}'
```
Output can be seen as below.
```json
{
 "pet": {
  "id": 12,
  "name": "mycat12"
 }
}
```