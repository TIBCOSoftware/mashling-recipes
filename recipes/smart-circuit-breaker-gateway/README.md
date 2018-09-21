# Gateway with a smart circuit breaker
This recipe is a gateway with a service protected by a smart circuit breaker.

## Installation
* Install [Go](https://golang.org/)
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/smart-circuit-breaker-gateway
```
Place the Downloaded Mashling-Gateway binary in smart-circuit-breaker-gateway folder.

## Testing
Start the gateway:
```
./mashling-gateway -c smart-circuit-breaker-gateway.json
```
and test below scenario.

### Smart Circuit breaker gets tripped
Start the gateway target service in a new terminal:
```
go run main.go -server
```

Now run the following in a new terminal:
```
curl http://localhost:9096/pets/1
```

You should see the following response:
```json
{
 "pet": {
  "category": {
   "id": 0,
   "name": "string"
  },
  "id": 1,
  "name": "sally",
  "photoUrls": [
   "string"
  ],
  "status": "available",
  "tags": [
   {
    "id": 0,
    "name": "string"
   }
  ]
 },
 "status": "available"
}
```
The target service is in a working state.

Now simulate a service failure by stopping the target service, and then running the following command:
```
curl http://localhost:9096/pets/1
```

Run the above command repeatedly until you see:
```json
{
 "error": "circuit breaker tripped"
}
```

The circuit breaker now has a high probability of blocking a request.

Start the gateway target service back up and repeatedly run the following command:
```
curl http://localhost:9096/pets/1
```

You should eventually see the following response:
```json
{
 "pet": {
  "category": {
   "id": 0,
   "name": "string"
  },
  "id": 1,
  "name": "sally",
  "photoUrls": [
   "string"
  ],
  "status": "available",
  "tags": [
   {
    "id": 0,
    "name": "string"
   }
  ]
 },
 "status": "available"
}
```
The circuit breaker now has a low probability of blocking a request, and the target service is working.
