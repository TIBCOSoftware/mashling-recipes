# Mashling Proxy with LDAP support

This readme contains instructions for creating a mashling HTTP proxy with
LDAP based Basic Auth.

## Installation
* Docker [docker](https://www.docker.com)
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Zipkin [zipkin](http://zipkin.io/pages/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/proxy-with-ldap
mashling create -f proxy-with-ldap.json proxy-with-ldap
cp -r cert proxy-with-ldap/
cp key.pem proxy-with-ldap/
```

## Testing
Start the LDAP server:
```
docker run -d -p 1234:389 pointlander/ldap
```
Start the proxy:
```
cd proxy-with-ldap
bin/proxy-with-ldap
```
In a new terminal run the following:
```
cd mashling-recipes/recipes/proxy-with-ldap/target
go run main.go
```
This will start up a server for the proxy to talk to.

To test the proxy start a new terminal and run the following:
```
cd mashling-recipes/recipes/proxy-with-ldap/proxy-with-ldap
curl -E cert/cert.pem -k --key key.pem -u john:johnldap -H "SOAPAction: test" -d '<xml>test</xml>'  https://localhost:9096/
```
Verify the request was received by viewing the terminal with the target.
Verify tracing worked by pointing your browser to: http://localhost:9411
