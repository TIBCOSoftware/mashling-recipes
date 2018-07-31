pre requisites:

1) protoc

2) protogen-go files

3) mashling gateway soursecode

get mashling and mashling recipe code

running :

cd $GOPATH\src\github.com\TIBCOSoftware\mashling-recipes\recipes\grpc-to-rest-gateway

go install ./...

mashling-cli.exe grpc generate -p petstore.proto

cd $GOPATH\src\github.com\TIBCOSoftware\mashling

go run build.go build




go run grpcClient.go -o 2 -p 9096 -n u2

go run grpcClient.go -p 9096 -o 1 -i 8

grpc-to-rest-gateway.exe -p 9096 -o 2 -n u2

grpc-to-rest-gateway.exe -p 9096 -o 1 -i 3


mashling-cli.exe grpc clean -p petstore.proto