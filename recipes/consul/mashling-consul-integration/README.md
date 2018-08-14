# Publish to Consul

This is a recipe to publish HTTP triggers in the gateway.json into Consul.

## Installation
Download [consul](https://www.consul.io/downloads.html) binary and update PATH environment variable to include consul binary.

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/consul/mashling-consul-integration
```

## Testing
Run the consul agent in secure mode by passing configuration json file
```
consul agent -dev -client <HOSTIP> -config-dir <CONFIG DIRECTORY PATH>
```
### #1 Register gateway services with consul:

Run below command to register gateway REST triggers with consul.
```
./mashling-cli publish consul -r -c mashling-gateway-consul.json -t b1gs33cr3t -H 127.0.0.1:8500
```

Registered services can be listed using curl command.
```
curl  --header  "X-Consul-Token: b1gs33cr3t"   http://localhost:8500/v1/agent/services
```

### De-Register gateway services from consul:

Run below command to de-register gateway REST triggers from consul.
```
./mashling-cli publish consul -d -c mashling-gateway-consul.json -t b1gs33cr3t -H 127.0.0.1:8500
```

### #2 Register gateway services with consul - using config directory option

To use this option consul agent should run on same host as mashling gateway is running. Also agent should be launched by providing configuration directory (i.e. -config-dir).

Run below command to register gateway REST triggers with consul.
```
./mashling-cli publish consul -r -c mashling-gateway-consul.json -t b1gs33cr3t -D <service defination directory>
```


### De-Register gateway services with consul - using config directory option

Run below command to de-register gateway REST triggers from consul.
```
./mashling-cli publish consul -d -c mashling-gateway-consul.json -t b1gs33cr3t -D <service defination directory>
```

### Health check

Registered services health status can be listed by using below curl command.
```
curl  --header  "X-Consul-Token: b1gs33cr3t"   http://localhost:8500/v1/agent/checks
```

### Consul dashboard

Consul dashboard can be accessed on browser - http://127.0.0.1:8500/ui


