# Secure REST Gateway Recipe
Sample REST gateway with mutual TLS (Transport Layer Security) enabled.

## Recipe usage instructions

1. Create gateway.
```bash
mashling create -f secure-rest-gateway.json secureGwApp
```

2. Copy gateway.crt & gateway.key into local directory (example: $HOME/gatewaycerts).<br>
3. Copy client.crt & apiserver.crt into local trust store directory (example: $HOME/truststore).<br>
4. Set below mentioned environment flags & run the gateway.

```bash
export SERVER_CERT=$HOME/gatewaycerts/gateway.crt
export SERVER_KEY=$HOME/gatewaycerts/gateway.key
export TRUST_STORE=$HOME/truststore
export ENDPOINT_URL=https://localhost:8080
cd secureGwApp/bin
./securegwapp
```

Note: For testing purposes, certificates are made available in utils folder. You can also generate self-signed certificates yourself by using open ssl.
```bash
openssl req \
       -newkey rsa:2048 -nodes -keyout server.key \
       -x509 -days 365 -out server.crt
```

5. Get go based sample client & server applications.

```bash
go get github.com/levigross/go-mutual-tls
```

6. Copy utils folder from this recipe to your working directory and run server application.

```bash
cd utils
go run server.go
```
7. Open another terminal and run client application.

```bash
go run client.go
```

8. Now you should see following response logged on the client terminal.

```json
{"Hobbies":["snowboarding","programming"],"Name":"Alex"}
```
