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
consul agent -dev -config-dir config-files
```
config-dir - provide path to directory of configuration files to load <br>

Sample configuration json file content:
```
{
  "acl_datacenter": "dc1",
  "acl_master_token": "b1gs33cr3t",
  "acl_default_policy": "deny",
  "acl_down_policy": "extend-cache"
}
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
Response :
```
{
 "restConfig": {
        "ID": "restConfig",
        "Service": "restConfig",
        "Tags": [],
        "Address": "<LOCAL MACHINE IP>",
        "Meta": {},
        "Port": 9096,
        "EnableTagOverride": false,
        "CreateIndex": 0,
        "ModifyIndex": 0
    },
"secureConfig": {
        "ID": "secureConfig",
        "Service": "secureConfig",
        "Tags": [],
        "Address": "<LOCAL MACHINE IP>",
        "Meta": {},
        "Port": 9098,
        "EnableTagOverride": false,
        "CreateIndex": 0,
        "ModifyIndex": 0
    }
}
```
### De-Register gateway services from consul:

Run below command to de-register gateway REST triggers from consul.
```
./mashling-cli publish consul -d -c mashling-gateway-consul.json -t b1gs33cr3t -H 127.0.0.1:8500
```

### #2 Register gateway services with consul - using config directory option

To use this option consul agent should run on same host as mashling gateway is running. Also agent should be launched by providing configuration directory (i.e. -config-dir).

service defination directory - Provide full path to config-dir

Run below command to register gateway REST triggers with consul. <br>
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
Response
```
{
    "service:restConfig": {
        "Node": "<LOCAL MACHINE HOSTNAME>",
        "CheckID": "service:restConfig",
        "Name": "Service 'restConfig' check",
        "Status": "critical",
        "Notes": "",
        "Output": "dial tcp <LOCAL MACHINE IP>:9096: i/o timeout",
        "ServiceID": "restConfig",
        "ServiceName": "restConfig",
        "ServiceTags": [],
        "Definition": {},
        "CreateIndex": 0,
        "ModifyIndex": 0
    },
    "service:secureConfig": {
        "Node": "<LOCAL MACHINE HOSTNAME>",
        "CheckID": "service:secureConfig",
        "Name": "Service 'secureConfig' check",
        "Status": "critical",
        "Notes": "",
        "Output": "dial tcp <LOCAL MACHINE IP>:9098: i/o timeout",
        "ServiceID": "secureConfig",
        "ServiceName": "secureConfig",
        "ServiceTags": [],
        "Definition": {},
        "CreateIndex": 0,
        "ModifyIndex": 0
    }
}
```
### Consul dashboard

Consul dashboard can be accessed on browser - http://127.0.0.1:8500/ui


