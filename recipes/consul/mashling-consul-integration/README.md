# Mashling integration with consul

This readme contains instructions for integrating mashling gateway app into consul.

## Installation
* consul [consul](https://www.consul.io/downloads.html)

## Setup
Download consul(https://www.consul.io/downloads.html) binary and register in path.

start consul agent service
```
consul agent -dev
```

check members in consul cluster
```
consul member
```

register a mashling gateway json into consul
```
mashling publish -a -consul <consul host address> -f <mashling gateway json>
```
de-register a mashling gateway json into consul
```
mashling publish -r -consul <consul host address> -f <mashling gateway json>
```

##Health Check
create a gateway app using mashling.json. Register it with consul using mashling cli.

to do --including health check details into consul--

Run the gateway binary. Open below URL to check the service health.
https://localhost:8500/ui

