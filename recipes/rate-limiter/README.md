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

### #1 Simple rate limiter to http service

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

You can run above `curl` command with different token to make sure that rate limit is applied per token basis. It is assumed that in real scenario only intended user possess the token.

Note: You may wish to change the rate limit and try, please refer [Mashling docs](https://github.com/TIBCOSoftware/mashling/tree/master/docs/gateway#services-rate-limiter) for more information.

### #2 Missing token

Run the following command:
```bash
curl http://localhost:9096/pets/1
```

You should see the following like response:
```json
{
 "status": "Token not found"
}
```

### #3 Global rate limiter
You can set global rate limit to a service (i.e. applies accross users) by using some hard coded token value. To do that modify rate limiter `step` in the gateway descriptor `rate-limiter-gateway.json` as follows:
```json
{
    "service": "RateLimiter",
    "input": {
        "token": "MY_GLOBAL_TOKEN"
    }
}
```

Re run the gateway:
```
./mashling-gateway -c rate-limiter-gateway.json
```

Run the following command more than 3 times:
```
curl http://localhost:9096/pets/1
```

From 4th time onwards you should observe that gateway is not allowing further calls.
