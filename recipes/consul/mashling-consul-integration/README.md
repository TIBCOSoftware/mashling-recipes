# Mashling integration with consul

This readme contains instructions for integrating mashling gateway app into consul.

## Setup
Download [consul](https://www.consul.io/downloads.html) binary and register in path.

start consul agent service
```
consul agent -dev
```
NOTE: Agent can be run in secure mode and also bind it to host ip, Use below command. Additional configuration details found [here](https://www.consul.io/docs/guides/acl.html)

```
agent -dev -client <host ip> -config-dir=<secure payload directory>
```

check members in consul cluster
```
consul members
```

register a mashling gateway app into consul
```
mashling publish -consul -f <mashling gateway json> -t <security token> -h <consul agent ip:port> -a
```
de-register a mashling gateway app from consul
```
mashling publish -consul -f <mashling gateway json> -t <security token> -h <consul agent ip:port> -r
```

## Health Check
create a gateway app using any mashling.json from available recipies and register it with consul using mashling cli.

Run the gateway binary. Open URL to check the service health.
http://[CONSUL IP:PORT]/ui
