# Gateway with basic Rate Limiter
This recipe is a gateway which applies rate limit on specified dispatches.

## Installation
* Install [Go](https://golang.org/)
* Download and build Mashling-Gateway from `feature-basic-rate-limiter-service` branch
 ```bash	
git clone -b feature-basic-rate-limiter-service --single-branch https://github.com/TIBCOSoftware/mashling.git $GOPATH/src/github.com/TIBCOSoftware/mashling	
cd $GOPATH/src/github.com/TIBCOSoftware/mashling	
go install ./...	
```

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/rate-limiter
```

## Testing
Start the gateway:
```
mashling-gateway -c rate-limiter-gateway.json
```

Run the following command:
```
curl http://localhost:9096/pets/1 -H "Token:TOKEN1"
```

You should see the following like response:
```json
{
 "category": {
  "id": 0,
  "name": "string"
 },
 "id": 1,
 "name": "cat",
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
}
```

Run the same curl command more than 5 times in a minute, 6th time onwards you should see the following response indicating that gateway not allowing further calls.

```json
{
    "status": "Rate Limit Exceeded - The service you have requested is over-capacity."
}
```
