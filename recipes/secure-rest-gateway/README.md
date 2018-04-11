# Mutual SSL HTTP Microgateway
This recipe is a HTTP based microgateway with mutual TLS enabled.

## Recipe usage instructions
1. Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)	
2. Setup:
```
   git clone https://github.com/TIBCOSoftware/mashling-recipes
   cd mashling-recipes/recipes/secure-rest-gateway
```
   Place the Downloaded Mashling-Gateway binary in secure-rest-gateway folder.

2. Copy gateway.crt & gateway.key into local directory (example: $HOME/gatewaycerts).<br>
3. Copy client.crt & apiserver.crt into local trust store directory (example: $HOME/truststore).<br>
4. Set below mentioned environment flags & run the gateway.

```bash
export SERVER_CERT=$HOME/gatewaycerts/gateway.crt
export SERVER_KEY=$HOME/gatewaycerts/gateway.key
export TRUST_STORE=$HOME/truststore
export ENDPOINT_URL=https://localhost:8080
cd secure-rest-gateway
./mashling-gateway -c secure-rest-gateway.json
```

Note: For testing purposes, certificates are made available in utils folder. You can also generate self-signed certificates yourself by using open ssl.
```bash
openssl req \
       -newkey rsa:2048 -nodes -keyout server.key \
       -x509 -days 365 -out server.crt
```

5. Get go based sample client & server applications.

```bash
go get -u github.com/levigross/go-mutual-tls/...
```

6. Copy client.crt, client.key & gateway.crt from utils folder to $GOPATH\src\github.com\levigross\go-mutual-tls and edit $GOPATH\src\github.com\levigross\go-mutual-tls\client\client.go as mentioned below.<br>

Change1:
```bash
cert, err := tls.LoadX509KeyPair("../cert.pem", "../key.pem") --> cert, err := tls.LoadX509KeyPair("../client.crt", "../client.key")
```

Change2:
```bash
clientCACert, err := ioutil.ReadFile("../cert.pem") --> clientCACert, err := ioutil.ReadFile("../gateway.crt")
```
Change3:
```bash
resp, err := grequests.Get("https://localhost:8080", ro) --> resp, err := grequests.Get("https://localhost:9098/pets/25", ro)
```

7. Copy apiserver.crt, apiserver.key & gateway.crt from utils folder to $GOPATH\src\github.com\levigross\go-mutual-tls and edit $GOPATH\src\github.com\levigross\go-mutual-tls\server\server.go as mentioned below.<br>

Change1:
Replace the line reads as
```bash
fmt.Fprintf(w, "Hello %v! \n", req.TLS.PeerCertificates[0].EmailAddresses[0])
```
with below 2 lines
```bash
w.Header().Set("Content-Type", "application/json")
w.Write([]byte(`{"Hobbies":["snowboarding","programming"],"Name":"Alex"}`))
```

Change2:
```bash
certBytes, err := ioutil.ReadFile("../cert.pem") --> certBytes, err := ioutil.ReadFile("../gateway.crt")
```

Change3:
```bash
CipherSuites: []uint16{tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384}, --> CipherSuites: []uint16{tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256},
```

Change4:
```bash
log.Println(httpServer.ListenAndServeTLS("../cert.pem", "../key.pem")) --> log.Println(httpServer.ListenAndServeTLS("../apiserver.crt", "../apiserver.key"))
```

8. Open one terminal and run server.go<br>

```bash
cd $GOPATH/src/github.com/levigross/go-mutual-tls/server
go run server.go
```

9. Open another terminal and run client.go<br>
```bash
cd $GOPATH/src/github.com/levigross/go-mutual-tls/client
go run client.go
```
10. Now you should see following response logged on the client terminal.<br>

```json
{"Hobbies":["snowboarding","programming"],"Name":"Alex"}
```
