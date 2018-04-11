# RestTrigger to KafkaPublisher recipe
This recipe publishes the Rest Trigger content payload to Kafka Topic as message.

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)
* Apache [Kafka](https://kafka.apache.org/quickstart)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/RestTrigger-To-KafkaPublisher
```
Place the Downloaded Mashling-Gateway binary in RestTrigger-To-KafkaPublisher folder.

## Testing

* Start Kafka Zookeeper & Broker in separate terminals.
* Start the consumer with the "syslog" topic in another terminal.
* Start RestTrigger-To-KafkaPublisher
```
./mashling-gateway -c RestTrigger-To-KafkaPublisher.json
```
* Use "PUT" operation and hit the url "http://localhost:9096/petEvent" with the below sample payload:

```json
{
	"category": {
		"id": 16,
		"name": "Animals"
	},
	"id": 16,
	"name": "SPARROW",
	"photoUrls": [
		"string"
	],
	"status": "sold",
	"tags": [{
		"id": 0,
		"name": "string"
	}]
}
```
* The payload content of the Rest trigger gets published to "syslog" Topic as message.
