# Mashling with MQTT and HTTP conditional routing.

This readme contains instructions for creating a mashling with support for conditional
MQTT and HTTP routing.

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Mosquitto [mosquitto](https://mosquitto.org/download/)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/mqtt-gateway
mashling create -f mqtt-gateway.json mqtt-gateway
```

## Testing
In another terminal start mqtt-gateway/bin/mqtt-gateway.
Then open another terminal and run:

```
mosquitto_sub -t "abc123"
```

Finally run the below:

```
mosquitto_pub -m "{\"pathParams\":{\"petId\":\"1\"},\"replyTo\":\"abc123\"}" -t "get"
```

The response will be printed in the terminal with the mosquitto_sub command.
If there isn't a response try running:

```
mosquitto_pub -m "{\"name\":\"SPARROW\",\"id\":1,\"photoUrls\":[],\"tags\":[]}" -t "put"
```

Then run:

```
mosquitto_pub -m "{\"pathParams\":{\"petId\":\"1\"},\"replyTo\":\"abc123\"}" -t "get"
```
