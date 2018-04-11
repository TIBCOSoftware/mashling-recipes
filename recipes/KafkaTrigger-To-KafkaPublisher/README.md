# KafkaTrigger to KafkaPublisher recipe
This recipe publishes kafka messages from one topic to the other.

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)
* Apache [Kafka](https://kafka.apache.org/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/KafkaTrigger-To-KafkaPublisher
```
Place the Downloaded Mashling-Gateway binary in KafkaTrigger-To-KafkaPublisher folder.

## Testing

* Start Kafka Zookeeper & Broker in separate terminals.
* Start the producer with the "publishpet" topic in another terminal.
* Start the consumer with the "subscribepet" topic in another terminal.
* Start the gateway:
```
./mashling-gateway -c KafkaTrigger-To-KafkaPublisher.json
```
* Post any message to the "publishpet" Topic and the message gets published to "subscribepet" Topic.
