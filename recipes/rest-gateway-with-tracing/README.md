# Mashling with distributed tracing

This readme contains instructions for creating a mashling with support for
distributed tracing.

## Installation
* Docker [docker](https://www.docker.com)
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Zipkin [zipkin](http://zipkin.io/pages/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/rest-gateway-with-tracing
mashling create -f rest-gateway-with-tracing.json rest-gateway-with-tracing
```

## Testing
In another terminal start rest-gateway-with-tracing/bin/rest-gateway-with-tracing
and then test with:

```
curl http://localhost:9096/pets/1
```

Then point your browser to http://localhost:9411
