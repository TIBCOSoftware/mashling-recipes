# Mashling integration with consul

This is a recipe to publish HTTP triggers in the gateway.json into Consul.

## Install
Download [consul](https://www.consul.io/downloads.html) binary and update PATH environment variable to include consul binary.

## Setup

Run consul agent using below command.
```
consul agent -dev -client <HOSTIP>
```
Note: Consul agent can be run in secure mode by providing authentication token in a configuration file while launching the agent.<br>
Sample configuration json file content:
```json
{
  "acl_datacenter": "dc1",
  "acl_master_token": "b1gs33cr3t",
  "acl_default_policy": "deny",
  "acl_down_policy": "extend-cache"
}
```
Additional configuration details found [here](https://www.consul.io/docs/guides/acl.html)

Command to run consul agent with the directory containing configuration json file.
```
consul agent -dev -client <HOSTIP> -config-dir <CONFIG DIRECTORY PATH>
```

## Testing

### Register and De-Register gateway service

Provided mashling-gateway-consul.json includes three triggers or services running on different ports.
Options '-a' and '-r' mutually exclusive used to register and de-register services.

Register service with consul:
```
mashling publish -consul -a -f mashling-gateway-consul.json -t b1gs33cr3t -h 127.0.0.1:8500
```

Check the services registered using consul UI.
1) Open consul UI http://127.0.0.1:8500/ui
2) Click on services tab
3) All the services provided in gateway json are listed there.


De-Register service with consul:
```
mashling publish -consul -r -f mashling-gateway-consul.json -t b1gs33cr3t -h 127.0.0.1:8500
```
Check the services de-registered using consul UI.
1) Open consul UI http://127.0.0.1:8500/ui
2) Click on services tab
3) All the services provided in gateway json are de-registered/removed from consul

#### Health Check
create a gateway app using any mashling.json from available recipies and register it with consul using mashling cli.

Run the gateway binary. Open URL to check the service health.
1) open consul ui url http://127.0.0.1:8500/ui
2) click on nodes, select respective agent node
3) Right side we can see all the registered services highlited in green / orange colour.

Green represents good health and Orange represent critical health.

### Using service defination folder option
Mashling cli is designed to support service defination folder option. This will generate consul service defination payload and stores it in user specified path.

NOTE: Consul agent should be present on local machine to load the services from created directory.

Register services:
```
mashling publish -consul -a -f mashling-gateway-consul.json -t b1gs33cr3t -d <service defination directory>
```

De-Register services:
```
mashling publish -consul -r -f mashling-gateway-consul.json -t b1gs33cr3t -d <service defination directory>
```

Check the services using curl command:
```
curl  --header  "X-Consul-Token: b1gs33cr3t"   http://localhost:8500/v1/agent/services
```
Check the services health using curl command.
```
curl  --header  "X-Consul-Token: b1gs33cr3t"   http://localhost:8500/v1/agent/checks
```
