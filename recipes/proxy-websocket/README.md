# WebSocket proxy gateway
This recipe is a proxy gateway for WebSocket end points.

## Installation
* Install [Go](https://golang.org/)
* Download the mashling-gateway binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)
* Install gorilla websocket `go` library
```bash
go get github.com/gorilla/websocket
```

## Setup

```bash
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/proxy-websocket
```
Place the downloaded mashling-gateway binary in proxy-websocket folder.

## Testing

Start the gateway:

```bash
.\mashling-gateway -c proxy-websocket.json
```

Start the echo WebSocket server:
```bash
go run main.go -server
```
### #1 Streaming through the gateway
Run the client:
```bash
go run main.go -client -name=CLIENT -url=ws://localhost:9096/ws
```

Now you should see client is able to send & receive WebSocket messages from echo server through the proxy gateway.

### #2 Limit number of concurrent connections

Run 2nd client:
```
bash
go run main.go -client -name=CLIENT2 -url=ws://localhost:9096/ws
```

Run 3rd client:
```
bash
go run main.go -client -name=CLIENT3 -url=ws://localhost:9096/ws
```

Now you should see that gateway rejecting 3rd client connection.

Note: You can change maximum allowed concurrent connections using `maxConnections` service setting.