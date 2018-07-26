# WebSocket proxy gateway
This recipe is a proxy gateway for WebSocket end points.

## Installation
* Install [Go](https://golang.org/)
* Download and build Mashling-Gateway from `feature-web-socket-support` branch

```bash
git clone -b feature-web-socket-support --single-branch https://github.com/TIBCOSoftware/mashling.git $GOPATH/src/github.com/TIBCOSoftware/mashling
cd $GOPATH/src/github.com/TIBCOSoftware/mashling
go install ./...
```
* Install gorilla websocket `go` library
```bash
go get github.com/gorilla/websocket
```

## Setup

```bash
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/proxy-websocket
```

## Testing

Start the gateway:

```bash
mashling-gateway -c proxy-websocket.json
```

Start the echo WebSocket server:
```bash
go run main.go -server
```

Run the client:
```bash
go run main.go -client -name=CLIENT -url=ws://localhost:9096/ws
```

Now you should see client is able to send & receive WebSocket messages from echo server through the proxy gateway.