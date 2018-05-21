# Mashling with distributed tracing

This readme contains instructions for creating a mashling with support for
distributed tracing.

## Installation
* Docker [docker](https://www.docker.com)
* Zipkin [zipkin](http://zipkin.io/pages/quickstart)
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/rest-gateway-with-tracing
```
Place the Downloaded Mashling-Gateway binary in rest-gateway-with-tracing folder.

## Testing
Start the Gateway:

```
./mashling-gateway -c rest-gateway-with-tracing.json
```

Test with:

```
curl http://localhost:9096/pets/1
```

For tracing point your browser to http://localhost:9411
