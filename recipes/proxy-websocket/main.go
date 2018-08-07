package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/gorilla/websocket"
)

const (
	// PingInterval interval between two consecutive client ping calls to server
	PingInterval time.Duration = 2
)

var (
	server = flag.Bool("server", false, "run the echo websocket server")
	client = flag.Bool("client", false, "run the client")

	name = flag.String("name", "CLIENTNAME", "instance name")
	url  = flag.String("url", "ws://localhost:8080/ws", "server url to connect")
)

func main() {
	flag.Parse()
	if *server {
		startServer()
	}
	if *client {
		runClient(*name, *url)
	}
}

// runClient connects to websocket server,
// sends message every 2 secs and listens to server connection.
func runClient(name string, serverURL string) {
	fmt.Println("Dialing", serverURL)
	conn, _, err := websocket.DefaultDialer.Dial(serverURL, nil)
	if err != nil {
		fmt.Println("conn err", err)
		return
	}
	defer conn.Close()

	exit := make(chan os.Signal, 1)
	signal.Notify(exit, os.Interrupt)

	//start listen & read websocket
	done := make(chan bool)
	go func() {
		defer close(done)
		for {
			_, message, err := conn.ReadMessage()
			if err != nil {
				fmt.Println("Read error", err)
				return
			}
			fmt.Println("Received:", string(message))
		}
	}()

	ticker := time.NewTicker(PingInterval * time.Second)
	defer ticker.Stop()

	count := 0
	for {
		select {
		case <-done:
			fmt.Println("DONE")
			return
		case t := <-ticker.C:
			//form message (client name + message count + timestamp)
			message := fmt.Sprintf("%s-%v-%v", name, count, t.Unix())
			count++
			fmt.Println("Sending:", message)
			err := conn.WriteMessage(websocket.TextMessage, []byte(message))
			if err != nil {
				fmt.Println("write err", err)
				return
			}
		case <-exit:
			fmt.Println("closing the client")
			close(exit)
			err := conn.WriteMessage(websocket.CloseMessage, websocket.FormatCloseMessage(websocket.CloseNormalClosure, "closing client"))
			if err != nil {
				fmt.Println("close err", err)
				return
			}
			//wait for a second so that server closes the connection
			select {
			case <-done:
			case <-time.After(time.Second):
			}
			return
		}
	}
}

// startServer starts echo websocket server on localhost:8080/ws
func startServer() {
	middleware := http.NewServeMux()
	middleware.HandleFunc("/ws", wsHandler)
	server := http.Server{
		Addr:    "localhost:8080",
		Handler: middleware,
	}
	fmt.Println("Starting server with echo websocket service at ws://localhost:8080/ws")
	log.Fatal(server.ListenAndServe())
}

func wsHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("received incomming request")

	upgrader := websocket.Upgrader{}
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		fmt.Println("upgrade error", err)
	} else {
		defer conn.Close()
		//upgraded to websocket connection
		clientAdd := conn.RemoteAddr()
		fmt.Println("Upgraded to websocket protocol")
		fmt.Println("Remote address:", clientAdd)

		for {
			mt, message, err := conn.ReadMessage()
			if err != nil {
				fmt.Println("read error", err)
				break
			}
			messageToLog := fmt.Sprintf("Received message(%s) from the client(%s)", message, clientAdd)
			fmt.Println(messageToLog)
			conn.WriteMessage(mt, []byte(message))
			if err != nil {
				fmt.Println("write error", err)
				break
			}
		}
		return
	}
}
