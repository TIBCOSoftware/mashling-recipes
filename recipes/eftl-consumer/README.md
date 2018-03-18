# EFTL Consumer
This recipe demonstrates the use of the EFTL trigger to generate HTTP requests from EFTL messages.

## Installation
* Docker [docker](https://www.docker.com)
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Zipkin [zipkin](http://zipkin.io/pages/quickstart)
* FTL [download](https://www.tibco.com/products/tibco-ftl);
Follow the installation instructions for your platform [here](https://docs.tibco.com/pub/ftl/5.3.2/doc/pdf/TIB_ftl_5.3_Installation.pdf)
* EFTL [download](https://www.tibco.com/products/tibco-eftl);
Follow the installation instructions for your platform [here](https://docs.tibco.com/pub/eftl/3.2.0/doc/html/GUID-9F5E7521-39B1-4DFD-B2E6-35164F9406CD.html)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/eftl-consumer
mashling create -f eftl-consumer.json eftl-consumer
go install github.com/gorilla/websocket
```

To start the EFTL server run:
```
go run helper/main.go -ftl
```

Then in another terminal run:
```
go run helper/main.go -eftl
```

## Testing
Open a terminal and run:
```
eftl-consumer/bin/eftl-consumer
```

Then open another terminal and start the target service:
```
go run target/main.go
```

Open another terminal and send two EFTL messages:
```
go run client/main.go
```

The target service should log two requests.
