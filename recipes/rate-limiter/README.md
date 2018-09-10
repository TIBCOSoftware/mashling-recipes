# Gateway with basic Rate Limiter
This recipe is a gateway which applies rate limit on specified dispatches.

## Installation
* Install [Go](https://golang.org/)
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/rate-limiter
```
Place the downloaded mashling-gateway binary in proxy-websocket folder.

## Testing
Start the gateway:
```
./mashling-gateway -c rate-limiter-gateway.json
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

Run the same curl command more than 3 times in a minute, 4th time onwards you should see the following response indicating that gateway not allowing further calls.

```json
{
    "status": "Rate Limit Exceeded - The service you have requested is over the allowed limit."
}
```
Note: You may wish to change the rate limit and try, please refer [Mashling docs](https://github.com/TIBCOSoftware/mashling/tree/master/docs/gateway#services-rate-limiter) for more information.
