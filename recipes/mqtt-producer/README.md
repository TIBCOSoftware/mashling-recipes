# MQTT Producer
This recipe is a HTTP to MQTT adapter

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Mosquitto [mosquitto](https://mosquitto.org/download/)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/mqtt-producer
mashling create -f mqtt-producer.json mqtt-producer
```

## Testing
In another terminal start mqtt-gateway/bin/mqtt-gateway.
Then open another terminal and run:

```
mosquitto_sub -t "test"
```

Finally run the below:

```
curl -d "{\"message\": \"hello world\"}" http://localhost:9096/test
```
