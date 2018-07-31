package main

import (
	"flag"
	"fmt"
	"log"

	pb "github.com/TIBCOSoftware/mashling-recipes/recipes/grpc-to-rest-gateway/petstore"

	"google.golang.org/grpc"

	"golang.org/x/net/context"

	"google.golang.org/grpc/metadata"
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
		GetPetById(client, id)
	case 2:
		GetUserByName(client, name)
	}
}

//GetUserByName comments
func GetUserByName(client pb.PetStoreServiceClient, name *string) {
	res, err := client.UserByName(context.Background(), &pb.UserByNameRequest{Username: *name})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("res :", res)
}

//GetPetById comments
func GetPetById(client pb.PetStoreServiceClient, id *int) {
	res, err := client.PetById(context.Background(), &pb.PetByIdRequest{Id: int32(*id)})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("res :", res)
}

//SendMetadata test comment
func SendMetadata(client pb.PetStoreServiceClient) {
	md := metadata.MD{}
	md["user"] = []string{"testuser"}
	md["password"] = []string{"passcode1"}
	ctx := context.Background()
	ctx = metadata.NewOutgoingContext(ctx, md)
	client.PetById(ctx, &pb.PetByIdRequest{})
}
