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

Copy created binary from rest-grpc-gateway-app folder to current.
```bash
cp ./rest-grpc-gateway-app/mashling-gateway* .
```
Rename mashling-gateway* to rest-grpc-gateway.

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
curl --request GET http://localhost:9096/pets/PetById/2
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
curl --request GET http://localhost:9096/users/UserByName/user2
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
### #3 Testing PetById method with PUT request
Payload
```json
{
    "id":2
}
```
Curl command
```curl
curl -X PUT "http://localhost:9096/pets/PetById" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"id":3}'
```
Output can be seen as below.
```json
{
 "pet": {
  "id": 3,
  "name": "cat3"
 }
}
```
### #4 Testing UserByName method with GET request and query params
Sample GET request with query params.
```curl
curl --request GET http://localhost:9096/users/UserByName?username=user3
```
Output can be seen as below.
```json
{
 "user": {
  "email": "email3",
  "id": 3,
  "phone": "phone3",
  "username": "user3"
 }
}
```