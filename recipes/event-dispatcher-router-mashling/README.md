# Event Dispatcher And Router
This recipe is an Apache Kafka based event dispatcher that conditionally routes events to various handlers based on content

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Apache [Kafka](https://kafka.apache.org/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/event-dispatcher-router-mashling
mashling create -f event-dispatcher-router-mashling.json <directory name for output>
```

## Testing

* Start Kafka Zookeeper & Broker in saparate terminals
* Start the producer with the "users" topic
* Start event-dispatcher-router-mashling/bin/event-dispatcher-router-mashling
* The below message can be posted to Kafka "users" topic to pick "usa_users_topic_handler" handler

Message:
```json
{"id":15,"country":"USA","category":{"id":0,"name":"string"},"name":"doggie","photoUrls":["string"],"tags":[{"id":0,"name":"string"}],"status":"available"}
```
