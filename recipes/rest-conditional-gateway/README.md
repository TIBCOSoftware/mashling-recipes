# Content-based HTTP Router
This recipe is a conditional HTTP router that routes requests based on content

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/rest-conditional-gateway
```
Place the Downloaded Mashling-Gateway binary in rest-conditional-gateway folder.

## Testing

Start the gateway:
```
./mashling-gateway -c rest-conditional-gateway.json
```
and test below scenarios.

### Content based routing
Request would be routed to corresponding handler as per the dispatch condition mentioned in the gateway descriptor.

Example: HTTP PUT request with the below payload would be routed through birds_handler

Payload
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
curl -X PUT "http://localhost:9096/pets" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"category":{"id":16,"name":"Animals"},"id":16,"name":"SPARROW","photoUrls":["string"],"status":"sold","tags":[{"id":0,"name":"string"}]}'
```

### Simple GET operation

Use below curl command to try GET request

```
curl --request GET http://localhost:9096/pets/17
```
