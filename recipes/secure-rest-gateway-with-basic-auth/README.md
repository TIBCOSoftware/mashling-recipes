# Secured Microgateway using Basic Authentication Recipe

This is a recipe to secure the microgateway with basic authentication.

Instructions:
1) Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage) 
2) Setup:
```
   git clone https://github.com/TIBCOSoftware/mashling-recipes
   cd mashling-recipes/recipes/secure-rest-gateway-with-basic-auth
```
Place the Downloaded Mashling-Gateway binary in secure-rest-gateway-with-basic-auth folder.

Note the setting:
```
"basicAuthFile": "${env.BASIC_AUTH_FILE}"
```

This is used to specify the environment variable to pass into the microgateway.

3) Start the microgateway with the BASIC_AUTH_FILE set to the full path to where your 
password file is located. The password file can be of the following form:

Plain (username:password):
```
foo:bar
tom:jerry
```

Hashed using SHA256 (username:salt:hashed)
```
foo:5VvmQnTXZ10wGZu_Gkjb8umfUPIOQTQ3p1YFadAWTl8=:6267beb3f851b7fee14011f6aa236556f35b186a6791b80b48341e990c367643
```

Start the microgateway:

```bash
export BASIC_AUTH_FILE=/path/to/passwd.txt
./mashling-gateway -c secure-rest-gateway-with-basic-auth.json
```

4) Test basic authentication with:
```bash
curl -X GET http://foo:bar@localhost:9096/pets/3
```

A 403 is obtained when the wrong credentials are supplied:
```bash
curl -v -X GET http://foo:badpass@localhost:9096/pets/3

*   Trying ::1...
* Connected to localhost (::1) port 9096 (#0)
* Server auth using Basic with user 'foo'
> GET /pets/3 HTTP/1.1
> Host: localhost:9096
> Authorization: Basic Zm9vOmJhZHBhc3M=
> User-Agent: curl/7.43.0
> Accept: */*
> 
< HTTP/1.1 403 Forbidden
< Access-Control-Allow-Origin: *
< X-Server-Instance-Id: 3c67d2634449bd40d994a96fa161d816
< Date: Wed, 11 Oct 2017 18:48:44 GMT
< Content-Length: 0
< Content-Type: text/plain; charset=utf-8
< 
* Connection #0 to host localhost left intact

```


