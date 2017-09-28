# RestTrigger to RestInvoker with conditional dispatch recipe

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/rest-conditional-gateway
mashling create -f rest-conditional-gateway.json rest-conditional-gateway
```

## Testing

In a saparate terminal start rest-conditional-gateway/bin/rest-conditional-gateway
and test below scenarios.

* Content based routing<br>
For birds handler to pickup use below payload.

```json
{
	"category": {
		"id": 16,
		"name": "Animals"
	},
	"id": 16,
	"name": "SPARROW",
	"photoUrls": [
		"string"
	],
	"status": "sold",
	"tags": [{
		"id": 0,
		"name": "string"
	}]
}
```
Curl command
```curl
curl 
```
* Header based routing
* Simple GET operation



5)Use "GET" operation and hit the url "http://localhost:9096/pets/16" to check the above added pet details.
