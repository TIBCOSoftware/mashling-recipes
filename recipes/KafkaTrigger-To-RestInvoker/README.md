# KafkaTrigger to RestInvoker recipe
This recipe uses kafka messages as input to the rest put operation.

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)
* Apache [Kafka](https://kafka.apache.org/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/KafkaTrigger-To-RestInvoker
mashling create -f KafkaTrigger-To-RestInvoker.json KafkaTrigger-To-RestInvoker
```
## Testing

* Start Kafka Zookeeper & Broker in separate terminals.
* Start the producer with the "syslog" topic in another terminal.
* Start KafkaTrigger-To-RestInvoker/bin/KafkaTrigger-To-RestInvoker
* Post the below message to the "syslog" Topic and the message payload gets updated to the swagger petstore.

```json
{"category":{"id":10,"name":"string"},"id":10,"name":"doggie","photoUrls":["string"],"status":"available","tags":[{"id":0,"name":"string"}]}
```
* Use "GET" operation and hit the swagger url "http://petstore.swagger.io/v2/pet/10" to get the updated pet details.
