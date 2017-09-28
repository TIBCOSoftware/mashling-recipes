# KafkaTrigger to KafkaPublisher recipe
This recipe publishes kafka messages from one topic to the other.

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Apache [Kafka](https://kafka.apache.org/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/KafkaTrigger-To-KafkaPublisher
mashling create -f KafkaTrigger-To-KafkaPublisher.json KafkaTrigger-To-KafkaPublisher
```
## Testing

* Start Kafka Zookeeper & Broker in separate terminals.
* Start the producer with the "publishpet" topic in another terminal.
* Start the consumer with the "subscribepet" topic in another terminal.
* Start KafkaTrigger-To-KafkaPublisher/bin/KafkaTrigger-To-KafkaPublisher
* Post any message to the "publishpet" Topic and the message gets published to "subscribepet" Topic.
