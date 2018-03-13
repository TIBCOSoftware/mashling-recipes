# MQTT Producer
This recipe demonstrates the use of EFTL

## Installation
* Docker [docker](https://www.docker.com)
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Zipkin [zipkin](http://zipkin.io/pages/quickstart)
* EFTL [eftl](https://www.tibco.com/products/tibco-eftl)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/eftl-gateway
mashling create -f eftl-gateway.json eftl-gateway
```

## Testing
Start the EFTL server. Open a terminal and run:
```
eftl-gateway/bin/eftl-gateway
```

Then open another terminal and run:
```
go run target/main.go
```

Open another terminal and run:
```
curl -d "{\"message\": \"hello world\"}" http://localhost:9096
```

The target service should log a request.
