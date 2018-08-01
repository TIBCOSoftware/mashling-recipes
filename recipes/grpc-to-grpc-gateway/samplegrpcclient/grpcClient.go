package main

import (
	"flag"
	"fmt"
	"log"

	pb "github.com/TIBCOSoftware/mashling-recipes/recipes/grpc-to-rest-gateway/petstore"

	"google.golang.org/grpc"

	"golang.org/x/net/context"
)

var addr string

func main() {

	option := flag.Int("o", 1, "command to run")
	id := flag.Int("i", 0, "id value")
	name := flag.String("n", "", "name value")
	port := flag.String("p", "", "port value")
	flag.Parse()
	addr = *port
	if len(*port) == 0 {
		addr = ":9000"
	}
	addr = ":" + *port

	fmt.Println("calling addr", addr)
	conn, err := grpc.Dial("localhost"+addr, grpc.WithInsecure())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()
	client := pb.NewPetStoreServiceClient(conn)

	switch *option {
	case 1:
		PetById(client, id)
	case 2:
		UserByName(client, name)
	}
}

//UserByName comments
func UserByName(client pb.PetStoreServiceClient, name *string) {
	res, err := client.UserByName(context.Background(), &pb.UserByNameRequest{Username: *name})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("res :", res)
}

//PetById comments
func PetById(client pb.PetStoreServiceClient, id *int) {
	res, err := client.PetById(context.Background(), &pb.PetByIdRequest{Id: int32(*id)})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("res :", res)
}
