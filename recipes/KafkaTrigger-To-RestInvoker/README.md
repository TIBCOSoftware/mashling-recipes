# KafkaTrigger to RestInvoker recipe
This recipe uses kafka messages as input to the rest put operation.

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)
* Apache [Kafka](https://kafka.apache.org/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/KafkaTrigger-To-RestInvoker
```
Place the Downloaded Mashling-Gateway binary in KafkaTrigger-To-RestInvoker folder.

## Testing

* Start Kafka Zookeeper & Broker in separate terminals.
* Start the producer with the "syslog" topic in another terminal.
* Start the gateway:
```
./mashling-gateway -c KafkaTrigger-To-RestInvoker.json
```
* Post the below message to the "syslog" Topic and the message payload gets updated to the swagger petstore.

```json
{"category":{"id":10,"name":"string"},"id":10,"name":"doggie","photoUrls":["string"],"status":"available","tags":[{"id":0,"name":"string"}]}
```
* Use "GET" operation and hit the swagger url "http://petstore.swagger.io/v2/pet/10" to get the updated pet details.
