package main

import (
	"flag"
	"fmt"
	"log"
	"net"

	pb "github.com/TIBCOSoftware/mashling-recipes/recipes/grpc-to-grpc-gateway/petstore"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

var addr string
var port *string

// ServerStrct is a stub for your Trigger implementation
type ServerStrct struct {
}

func main() {
	port = flag.String("port", "9000", "port value")
	flag.Parse()

	if len(*port) == 0 {
		addr = ":9000"
	}

	addr = ":" + *port

	lis, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}

	s := grpc.NewServer()

	pb.RegisterPetStoreServiceServer(s, new(ServerStrct))

	log.Println("Starting server on port: ", addr)

	s.Serve(lis)

}

func (t *ServerStrct) PetById(ctx context.Context, req *pb.PetByIdRequest) (*pb.PetResponse, error) {

	fmt.Println("server PetById method called")

	petArr := []pb.Pet{
		{
			Id:   2,
			Name: "cat2",
		},
		{
			Id:   3,
			Name: "cat3",
		},
		{
			Id:   4,
			Name: "cat4",
		},
	}

	for _, pet := range petArr {
		if pet.Id == req.Id {
			return &pb.PetResponse{Pet: &pet}, nil
		}
	}

	var pet = pb.Pet{
		Id:   1,
		Name: "defcat",
	}
	return &pb.PetResponse{Pet: &pet}, nil

}

func (t *ServerStrct) UserByName(ctx context.Context, req *pb.UserByNameRequest) (*pb.UserResponse, error) {

	fmt.Println("server UserByName method called")
	userArr := []pb.User{
		{
			Id:       2,
			Username: "user2",
			Email:    "email2",
			Phone:    "phone2",
		},
		{
			Id:       3,
			Username: "user3",
			Email:    "email3",
			Phone:    "phone3",
		},
		{
			Id:       4,
			Username: "user4",
			Email:    "email4",
			Phone:    "phone4",
		},
	}

	for _, user := range userArr {
		if req.Username == user.Username {
			return &pb.UserResponse{User: &user}, nil
		}
	}

	var user = pb.User{
		Id:       1,
		Username: "defuser",
		Email:    "defemail",
		Phone:    "defphone",
	}
	return &pb.UserResponse{User: &user}, nil

}
