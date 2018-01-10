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
consul agent -dev -client <host ip> -config-dir=<configuration files dir>
```

## Registering and De-Registering mashling gateway

Provided mashling-gateway-consul.json includes three triggers or services running on different ports.
Flags '-a' and '-r' used to register and de-register.

register a mashling gateway app into consul
```
mashling publish -consul -a -f <mashling gateway json> -t <security token> -h <consul agent ip:port>
```

Check the services registered using consul UI.
1) open consul UI http://[CONSUL IP:PORT]/ui
2) click on services tab
3) All the triggers/services provided in gateway json are registered with consul


de-register a mashling gateway app from consul
```
mashling publish -consul -r -f <mashling gateway json> -t <security token> -h <consul agent ip:port>
```
Check the services de-registered using consul UI.
1) open consul UI http://[CONSUL IP:PORT]/ui
2) click on services tab
3) All the triggers/services provided in gateway json are de-registered/removed from consul

## Health Check
create a gateway app using any mashling.json from available recipies and register it with consul using mashling cli.

Run the gateway binary. Open URL to check the service health.
1) open consul ui url http://[CONSUL IP:PORT]/ui
2) click on nodes, selct respective agent node
3) on right side we can see all the registered services highlited in green / orange colour.

Green represents good health and Orange represent critical health.
