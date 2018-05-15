# Event Dispatcher And Router
This recipe is an Apache Kafka<sup>TM</sup> based event dispatcher that conditionally routes events to various handlers based on content

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)
* Apache [Kafka](https://kafka.apache.org/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/event-dispatcher-router-mashling
```
Place the Downloaded Mashling-Gateway binary in event-dispatcher-router-mashling folder.

## Testing

* Start Kafka Zookeeper & Broker in separate terminals
* Start the producer with the "users" topic
* Start gateway:
```
./mashling-gateway -c event-dispatcher-router-mashling.json
```

* Send below sample message via Kafka producer on the "users" topic 
* "usa_users_topic_handler" processes this message

Message:
```json
{"id":15,"country":"USA","category":{"id":0,"name":"string"},"name":"doggie","photoUrls":["string"],"tags":[{"id":0,"name":"string"}],"status":"available"}
```
