# KafkaTrigger to RestInvoker with conditional dispatch

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/event-dispatcher-router-mashling
mashling create -f event-dispatcher-router-mashling.json event-dispatcher-router-mashling
```

## Testing

* Start the Kafka Zookeeper.
* Start the Kafka Broker in another terminal.
* In a separate terminal start event-dispatcher-router-mashling/bin/event-dispatcher-router-mashling
* Start the producer with the "users" topic.
* The below message can be posted to Kafka "users" topic to pick "usa_users_topic_handler" handler.

Message for the topic:
```json
{"country":"USA"}
```
The message payload can be changed according to the condition to pick other handlers.
