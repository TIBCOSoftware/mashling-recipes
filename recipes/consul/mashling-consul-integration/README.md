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
mashling publish -consul -f <mashling gateway json> -t <security token> -a
```
de-register a mashling gateway app from consul
```
mashling publish -consul -f <mashling gateway json> -t <security token> -r
```

## Health Check
create a gateway app using any mashling.json from available recipies and register it with consul using mashling cli.

to do --include health check details into consul--

Run the gateway binary. Open URL to check the service health.
https://localhost:8500/ui
