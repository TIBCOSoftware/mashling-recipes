# MQTT Producer
This recipe is a HTTP to MQTT adapter

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)
* Mosquitto [mosquitto](https://mosquitto.org/download/)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/mqtt-producer
```
Place the Downloaded Mashling-Gateway binary in mqtt-producer folder.

## Testing
In another terminal start mqtt-gateway:

```
./mashling-gateway -c mqtt-gateway.json
```

Then open another terminal and run:

```
mosquitto_sub -t "test"
```

Finally run the below:

```
curl -d "{\"message\": \"hello world\"}" http://localhost:9096/test
```
