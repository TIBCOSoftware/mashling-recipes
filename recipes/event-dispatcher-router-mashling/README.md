# KafkaTrigger to RestInvoker with conditional dispatch
This recipe routes kafka messages to corresponding REST handlers based kafka message content.

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Apache [Kafka](https://kafka.apache.org/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/event-dispatcher-router-mashling
mashling create -f event-dispatcher-router-mashling.json event-dispatcher-router-mashling
```

## Testing

* Start Kafka Zookeeper & Broker in separate terminals
* Start the producer with the "users" topic
* Start event-dispatcher-router-mashling/bin/event-dispatcher-router-mashling
* The below message can be posted to Kafka "users" topic to pick "usa_users_topic_handler" handler

Message:
```json
{"country":"USA"}
```
