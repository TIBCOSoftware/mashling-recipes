# Publish to Consul

This is a recipe to publish HTTP triggers in the gateway.json into Consul.

## Installation
* Download [consul](https://www.consul.io/downloads.html) binary and update PATH environment variable to include consul binary.
* Download the Mashling-cli Linux Binary from [Mashling-releases](https://github.com/TIBCOSoftware/mashling/releases).

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/consul/mashling-consul-integration
```
Place the downloaded mashling-cli and mashling-gateway binary in mashling-consul-integration folder

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
Run the mashling-gateway using below command
```
./mashling-gateway -c mashling-gateway-consul.json
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
    }
}
```
Note : Registered services can be accessed from consul dashboard - http://127.0.0.1:8500/ui <br>
Update consul token in dashboard settings page

### De-Register gateway services from consul:

Run below command to de-register gateway REST triggers from consul.
```
./mashling-cli publish consul -d -c mashling-gateway-consul.json -t b1gs33cr3t -H 127.0.0.1:8500
```

### #2 Register gateway services with consul - using config directory option

Run below command to register gateway REST triggers with consul using config directory option. <br>
```
./mashling-cli publish consul -r -c mashling-gateway-consul.json -t b1gs33cr3t -D <Service definition directory>
```
Service definition directory - Provide full path to config-dir

Run the mashling-gateway using below command
```
./mashling-gateway -c mashling-gateway-consul.json
```
Note : After starting gateway wait for 30 secs and perform health check
### Health check

Registered services health status can be listed by using below curl command.
```
curl  --header  "X-Consul-Token: b1gs33cr3t"   http://localhost:8500/v1/agent/checks
```
Response
```
{
    "service:restConfig": {
        "Node": "<HOSTNAME>",
        "CheckID": "service:restConfig",
        "Name": "Service 'restConfig' check",
        "Status": "passing",
        "Notes": "",
        "Output": "TCP connect <LOCAL MACHINE IP>:9096: Success",
        "ServiceID": "restConfig",
        "ServiceName": "restConfig",
        "ServiceTags": [],
        "Definition": {},
        "CreateIndex": 0,
        "ModifyIndex": 0
    }
}
```
### De-Register gateway services with consul - using config directory option

Run below command to de-register gateway REST triggers from consul.
```
./mashling-cli publish consul -d -c mashling-gateway-consul.json -t b1gs33cr3t -D <Service definition directory>
```


