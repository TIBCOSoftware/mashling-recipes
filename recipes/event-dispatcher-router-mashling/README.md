# KafkaTrigger to RestInvoker with conditional dispatch recipe

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/event-dispatcher-router-mashling
mashling create -f event-dispatcher-router-mashling.json event-dispatcher-router-mashling
```

## Testing

In a separate terminal start event-dispatcher-router-mashling/bin/event-dispatcher-router-mashling
and test below scenarios.

* Content based routing<br>
For picking the usa_users_topic_handler handler use below payload.

```json
{
	"country": "USA"
}
```
Message for the topic:
```json
{"country":"USA"}
```

Publish the above message in the Kafka "users" topic. The message payload can be changed according to the condition to pick other handlers.
