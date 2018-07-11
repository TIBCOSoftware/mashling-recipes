# Gateway with anomaly detection
This recipe is a gateway with anomaly detection.

## Installation
* Install [Go](https://golang.org/)
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/anomaly-gateway
```
Place the Downloaded Mashling-Gateway binary in anomaly-gateway folder.

## Testing
Start the gateway:
```
./mashling-gateway -c anomaly-gateway.json
```
and test below scenario.

### Payload that is an anomaly
Run the following command:
```
go run main.go -server
```

Then open a new terminal and run:
```
go run main.go -client
```

You should see the following:
```
number of anomalies 0
average complexity NaN
```

Now run the following:
```
curl http://localhost:9096/test --upload-file anomaly-payload.json
```

You should see the following response:
```json
{
 "complexity": 9.124694,
 "error": "anomaly!"
}
```
