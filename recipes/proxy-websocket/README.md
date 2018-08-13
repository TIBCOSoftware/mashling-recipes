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
./mashling-gateway -c proxy-websocket.json
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
```bash
go run main.go -client -name=CLIENT2 -url=ws://localhost:9096/ws
```

Run 3rd client:
```bash
go run main.go -client -name=CLIENT3 -url=ws://localhost:9096/ws
```

Now you should see that gateway rejecting 3rd client connection.

Note: You can change maximum allowed concurrent connections using `maxConnections` service setting.

### #3 Secure websocket proxy gateway with `Basic Authentication`

Note that gateway can be secured with `basicauth`using the trigger setting:

```json
"basicAuthFile": "${env.BASIC_AUTH_FILE}"
```

#### 1. Start the microgateway with the BASIC_AUTH_FILE set to the full path to where your password file is located. The password file can be of the following form:

Plain (username:password)
```
foo:bar
tom:jerry
```

Hashed using SHA256 (username:salt:hashed)
```json
foo:5VvmQnTXZ10wGZu_Gkjb8umfUPIOQTQ3p1YFadAWTl8=:6267beb3f851b7fee14011f6aa236556f35b186a6791b80b48341e990c367643
```

Start the gateway:
```bash
export BASIC_AUTH_FILE=/path/to/password.txt
./mashling-gateway -c proxy-websocket.json
```

#### 2. Run the client with basicauth credentials:
```bash
go run main.go -client -url=ws://localhost:9096/ws -basicauth=foo:bar
```

Note that client fails to establish websocket connection when wrong credentials are supplied.

