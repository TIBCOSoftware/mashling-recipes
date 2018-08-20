package main

import (
	"errors"
	"flag"
	"fmt"
	"log"
	"net"
	"strconv"
	"strings"

	pb "rest-to-grpc-gateway/petstore"

	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

var addr string
var clientAddr string

// ServerStrct is a stub for your Trigger implementation
type ServerStrct struct {
}

var petMapArr = make(map[int32]pb.Pet)
var userMapArr = make(map[string]pb.User)

var petArr = []pb.Pet{
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
var userArr = []pb.User{
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

func main() {

	for _, pet := range petArr {
		petMapArr[pet.GetId()] = pet
	}

	for _, user := range userArr {
		userMapArr[user.GetUsername()] = user
	}

	clientMode := flag.Bool("client", false, "command to run client")
	serverMode := flag.Bool("server", false, "command to run server")
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
	} else if *serverMode {
		callServer()
	} else {
		fmt.Println("please choose server or client")
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

func callServer() {
	addr = ":9000"
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

	for _, pet := range petMapArr {
		if pet.Id == req.Id {
			return &pb.PetResponse{Pet: &pet}, nil
		}
	}

	return nil, errors.New("Pet not found")

}

func (t *ServerStrct) UserByName(ctx context.Context, req *pb.UserByNameRequest) (*pb.UserResponse, error) {

	fmt.Println("server UserByName method called")

	for _, user := range userMapArr {
		if req.Username == user.Username {
			return &pb.UserResponse{User: &user}, nil
		}
	}

	return nil, errors.New("User not found")

}

func (t *ServerStrct) PetPUT(ctx context.Context, req *pb.PetRequest) (*pb.PetResponse, error) {

	fmt.Println("server PetPUT method called")
	if req.Pet == nil {
		return nil, errors.New("Content not found. Invalid Request")
	}
	if req.Pet.Id == 0 {
		return nil, errors.New("Invalid id provided")
	} else {
		fmt.Println("Request recieved for id:", req.Pet.Id)
	}

	for id := range petMapArr {
		if id == req.Pet.GetId() {
			petMapArr[id] = *req.GetPet()
		} else {
			petMapArr[req.GetPet().GetId()] = *req.GetPet()
		}
	}

	var pet = petMapArr[req.GetPet().GetId()]
	return &pb.PetResponse{Pet: &pet}, nil
}

func (t *ServerStrct) UserPUT(ctx context.Context, req *pb.UserRequest) (*pb.UserResponse, error) {

	fmt.Println("server UserPUT method called")
	if req.User == nil {
		return nil, errors.New("Content not found. Invalid Request")
	}

	if len(req.User.Username) == 0 {
		return nil, errors.New("Invalid Username provided")
	} else {
		fmt.Println("Request recieved for username:", req.User.Username)
	}

	for name := range userMapArr {
		if strings.Compare(name, req.User.GetUsername()) == 0 {
			userMapArr[name] = *req.GetUser()
		} else {
			userMapArr[req.GetUser().GetUsername()] = *req.GetUser()
		}
	}

	var user = userMapArr[req.GetUser().GetUsername()]
	return &pb.UserResponse{User: &user}, nil
}
