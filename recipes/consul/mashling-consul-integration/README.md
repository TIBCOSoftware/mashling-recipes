# Mashling integration with consul

This readme contains instructions for integrating mashling gateway app into consul.

## Setup
Download [consul](https://www.consul.io/downloads.html) binary and register in path.

start consul agent service
```
consul agent -dev
```

check members in consul cluster
```
consul members
```

register a mashling gateway app into consul
```
mashling publish -a -consul <consul host address> -f <mashling gateway json>
```
de-register a mashling gateway app from consul
```
mashling publish -r -consul <consul host address> -f <mashling gateway json>
```

##Health Check
create a gateway app using mashling.json. Register it with consul using mashling cli.

to do --including health check details into consul--

Run the gateway binary. Open URL to check the service health.
https://localhost:8500/ui

