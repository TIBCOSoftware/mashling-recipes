# Secure REST Conditional Gateway Recipe
Sample REST conditional gateway with TLS (Transport Layer Security) is enabled.

## Recipe usage instructions

1. Create gateway.
```bash
mashling create -f secure-rest-conditional-gateway.json secureGwApp
```

2. Copy gateway.crt & gateway.key into secureGwApp/bin folder.<br>
3. Create new directory secureGwApp/bin/truststore abd copy client.crt & apiserver.crt into secureGwApp/bin/truststore folder. <br>
4. Run gateway.

```bash
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
