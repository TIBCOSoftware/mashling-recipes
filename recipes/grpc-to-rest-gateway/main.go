package main

import (
	"flag"
	"fmt"
	"log"
	"strconv"
	"strings"

	pb "grpc-to-rest-gateway/petstore"

	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

var addr string
var clientAddr string

func main() {

	clientMode := flag.Bool("client", false, "command to run client")
	methodName := flag.String("method", "pet", "method name")
	paramVal := flag.String("param", "user2", "method param")
	port := flag.String("port", "", "port value")

	flag.Parse()
	var id int

	if *clientMode {
		if strings.Compare(*methodName, "pet") == 0 {
			id, _ = strconv.Atoi(*paramVal)
		}
		callClient(port, methodName, id, *paramVal)
	} else {
		fmt.Println("please choose client")
	}
}

func callClient(port *string, option *string, id int, name string) {
	clientAddr = *port
	if len(*port) == 0 {
		clientAddr = ":9000"
	}
	clientAddr = ":" + *port
	conn, err := grpc.Dial("localhost"+clientAddr, grpc.WithInsecure())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()
	client := pb.NewPetStoreServiceClient(conn)

	switch *option {
	case "pet":
		PetById(client, id)
	case "user":
		UserByName(client, name)
	case "petput":
		PetPUT(client, name)

	}
}

//UserByName comments
func UserByName(client pb.PetStoreServiceClient, name string) {
	res, err := client.UserByName(context.Background(), &pb.UserByNameRequest{Username: name})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("res :", res)
}

//PetById comments
func PetById(client pb.PetStoreServiceClient, id int) {
	res, err := client.PetById(context.Background(), &pb.PetByIdRequest{Id: int32(id)})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("res :", res)
}

func PetPUT(client pb.PetStoreServiceClient, payload string) {

	name := strings.Split(payload, ",")[1]
	id, _ := strconv.ParseInt(strings.Split(payload, ",")[0], 0, 64)
	if id == 0 {
		log.Fatal("please provide valid id")
	}
	petReq := &pb.PetRequest{Id: int32(id), Name: name}
	fmt.Println("requesting pay load", petReq)
	res, err := client.PetPUT(context.Background(), petReq)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("res :", res)

}
