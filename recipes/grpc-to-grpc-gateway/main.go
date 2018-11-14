package main

import (
	"errors"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"time"

	pb "grpc-to-grpc-gateway/petstore"

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

var recUserArrClient = make([]pb.User, 0)
var recUserArrServer = make([]pb.User, 0)

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

var sendUserDataClient = []pb.User{
	{
		Id:       22,
		Username: "user22c",
		Email:    "email22c",
		Phone:    "phone22c",
	},
	{
		Id:       23,
		Username: "user23c",
		Email:    "email23c",
		Phone:    "phone23c",
	},
	{
		Id:       24,
		Username: "user24c",
		Email:    "email24c",
		Phone:    "phone24c",
	},
}

var sendUserDataServer = []pb.User{
	{
		Id:       32,
		Username: "user32s",
		Email:    "email32s",
		Phone:    "phone32s",
	},
	{
		Id:       33,
		Username: "user33s",
		Email:    "email33s",
		Phone:    "phone33s",
	},
	{
		Id:       34,
		Username: "user34s",
		Email:    "email34s",
		Phone:    "phone34s",
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
	case "listusers":
		ListUsers(client)
	case "storeusers":
		StoreUsers(client)
	case "bulkusers":
		BulkUsers(client)
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

func ListUsers(client pb.PetStoreServiceClient) {
	stream, err := client.ListUsers(context.Background(), &pb.EmptyReq{Msg: "list of users"})
	if err != nil {
		fmt.Println("erorr occured in ListUsers", err)
	}
	for {
		users, err := stream.Recv()
		if err == io.EOF {
			break
		}
		if err != nil {
			fmt.Println("erorr occured while recieving ", err)
		}
		fmt.Println("RECEIVED: ", users.GetUsername())
	}
}

func StoreUsers(client pb.PetStoreServiceClient) {
	stream, err := client.StoreUsers(context.Background())
	if err != nil {
		fmt.Println("erorr occured in StoreUsers", err)
	}
	var i = 0
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)

	waitc := make(chan struct{})
	go func() {
		for {
			select {
			case <-c:
				close(waitc)
				i = 0
				return
			default:
				i++
				user := pb.User{
					Username: "cuser" + strconv.Itoa(i),
					Id:       int32(i),
					Email:    "cemail" + strconv.Itoa(i),
				}
				fmt.Println("SEND: ", user.Username)
				if err := stream.Send(&user); err != nil {
					fmt.Println("error while sending user", user, err)
					close(waitc)
					return
				}

			}
		}
	}()
	<-waitc
	reply, err := stream.CloseAndRecv()
	if err != nil {
		fmt.Println("erorr occured in StoreUsers response", err)
	} else {
		fmt.Println("response received from server:", reply)
	}

}

func BulkUsers(client pb.PetStoreServiceClient) {
	stream, err := client.BulkUsers(context.Background())
	if err != nil {
		fmt.Println("error in streaming of bulk users", err)
	}
	var rc = 0
	waitc := make(chan struct{})
	go func() {
		for {
			time.Sleep(time.Second)
			user, err := stream.Recv()
			if err == io.EOF {
				// read done.
				fmt.Println("received total: ", strconv.Itoa(rc))
				recUserArrClient = nil
				close(waitc)
				return
			}
			if err != nil {
				log.Fatalf("Failed to receive a user : %v", err)
				close(waitc)
				return
			}
			if user != nil {
				rc++
				fmt.Println("RECEIVED:  ", user.GetUsername())
			}

		}
	}()
	for i := 0; i < 10; i++ {
		user := pb.User{
			Username: "cuser" + strconv.Itoa(i),
			Id:       int32(i),
			Email:    "cemail" + strconv.Itoa(i),
		}
		fmt.Println("SEND: ", user.Username)
		if err := stream.Send(&user); err != nil {
			fmt.Println("error while sending user", user, err)
			os.Exit(0)
		}
		time.Sleep(time.Second)
	}
	stream.CloseSend()
	<-waitc
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

func (t *ServerStrct) ListUsers(req *pb.EmptyReq, sReq pb.PetStoreService_ListUsersServer) error {
	fmt.Println("server ListUsers method called")
	fmt.Println("request received from client ", req)
	var i = 0

	exit := make(chan os.Signal, 1)
	signal.Notify(exit, os.Interrupt)

	for {
		select {
		case <-exit:
			fmt.Println("total users sent:", strconv.Itoa(i))
			close(exit)
			return nil
		default:
			i++
			user := pb.User{
				Username: "suser" + strconv.Itoa(i),
				Id:       int32(i),
				Email:    "semail" + strconv.Itoa(i),
			}
			fmt.Println("SEND: ", user.Username)
			err := sReq.Send(&user)
			if err != nil {
				fmt.Println("unable to send:", err)
				os.Exit(0)
			}
		}
	}
}
func (t *ServerStrct) StoreUsers(cReq pb.PetStoreService_StoreUsersServer) error {
	fmt.Println("server StoreUsers method called")
	var i = 0
	for {
		userData, err := cReq.Recv()
		if userData != nil {
			i++
			fmt.Println("RECEIVED: ", userData.GetUsername())
		}
		if err == io.EOF {
			return cReq.SendAndClose(&pb.EmptyRes{Msg: "received total users:" + strconv.Itoa(i)})
		}
		if err != nil {
			return err
		}
	}
}
func (t *ServerStrct) BulkUsers(bReq pb.PetStoreService_BulkUsersServer) error {
	fmt.Println("server BulkUsers method called")
	var rc = 0
	waits := make(chan struct{})
	go func() {
		for {
			time.Sleep(time.Second)
			userData, err := bReq.Recv()
			if userData != nil {
				rc++
				fmt.Println("RECEIVED: ", userData.GetUsername())
			}
			if err == io.EOF {
				fmt.Println("total records received: ", strconv.Itoa(rc))
				close(waits)
				return
			}
			if err != nil {
				fmt.Println("error occured while receiving", err)
				close(waits)
				return
			}
		}
	}()
	for i := 0; i < 10; i++ {
		user := pb.User{
			Username: "suser" + strconv.Itoa(i),
			Id:       int32(i),
			Email:    "semail" + strconv.Itoa(i),
		}
		fmt.Println("SEND: ", user.Username)
		if err := bReq.Send(&user); err != nil {
			fmt.Println("error while sending user", user, err)
			return err
		}
		time.Sleep(time.Second)
	}
	<-waits
	return nil
}
