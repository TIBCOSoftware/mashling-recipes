# Secure REST Conditional Gateway Recipe
Sample REST conditional gateway with TLS (Transport Layer Security) is enabled along with client authentication.

## Recipe usage instructions

```bash
mashling create -f secure-rest-conditional-gateway.json secureGwApp
```

copy gateway.crt & gateway.key into secureGwApp/bin folder
create new directory secureGwApp/bin/truststore
copy client.crt & apiserver.crt into secureGwApp/bin/truststore folder

```bash
cd secureGwApp/bin
./securegwapp
```

Note: Certificates are made available inside utils folder.

```bash
go get github.com/levigross/go-mutual-tls
```

Open new terminal for server

```bash
cd utils
go run server.go
```


Open new terminal for client
```bash
cd utils
go run client.go
```