# MQTT FaaS Dispatcher
MQTT trigger that content routes to either a AWS Lambda function or an endpoint for Live Apps case creation

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)
* Mosquitto [mosquitto](https://mosquitto.org/download/)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/mqtt-lambda-tci
```
Place the Downloaded Mashling-Gateway binary in mqtt-lambda-tci folder.

## Testing

Start gateway:
```
./mashling-gateway -c mqtt-lambda-tci.json
```

Then open another terminal and run:
```
mosquitto_sub -t "abc123"
```

Run the below:
* If alert type is "critical" or "urgent", a TIBCO Cloud flow is initiated which submits a Live Apps case
```
mosquitto_pub -m '{"type": "urgent", "name": "Jeff Zoe", "ph": "7324567438", "email": "jeff.zoe@techsupport.com","description": "General device malfunction", "pathParams":{"caseid":"2"}, "replyTo":"abc123"}' -t 'alert'
```
* If alert type is "non-critical", an AWS Lambda function is initiated
```
mosquitto_pub -m '{"type": "non-critical","name": "Mary Plum", "ph": "7324567438", "email": "maryplum@techsupport.com","description": "General device malfunction", "pathParams":{"caseid":"2"}, "replyTo":"abc123"}' -t 'alert'
```


