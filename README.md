# Mashling integration with lyft/envoy front-proxy

> **Mashling** as a member of the **lyft/envoy** front-proxy mesh

## Installation
### Prerequisites
* Docker tools [docker, compose, machine](https://www.docker.com/products/docker-toolbox) 
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling-cli)


## Getting Started

### Get the source code

	git clone https://github.com/TIBCOSoftware/mashling-envoy-front-proxy front-proxy
	cd front-proxy
	
Create a docker-machine

	docker-machine create --driver virtualbox default
	eval $(docker-machine env default)

### Create a sample mashling app and deploy it in Envoy front-proxy
#### Command
	$jdoe-machine:front-proxy jdoe$ pwd
	/Users/jdoe/front-proxy
	
	$jdoe-machine:front-proxy jdoe$ ./createMashlingOnEnvoy.sh 
	
This will create a sample mashling app named 'sample-mashling-app' under /Users/jdoe/front-proxy/gateway folder.
 
This will also create an envoy front-proxy setup with the 'sample-mashling-app' as a member of the envoy mesh.

The 'sample-mashling-app' app will expose the endpoint (/pets/1)

Access the mashling service (service3) behind the proxy as
> curl -v $(docker-machine ip default):8000/pets/1

### Create a mashling app using a mashling json descriptor and deploy it in Envoy front-proxy
#### Command
	$jdoe-machine:front-proxy jdoe$ pwd
	/Users/jdoe/front-proxy
	
	$jdoe-machine:front-proxy jdoe$ ./createMashlingOnEnvoy.sh -n petstoreapp -f ~/Work/mashling/request-response-mashling.json

This will create a sample mashling app named 'sample-mashling-app' under /Users/jdoe/front-proxy/gateway folder.
 
This will also create an envoy front-proxy setup with the 'sample-mashling-app' as a member of the envoy mesh.

The 'sample-mashling-app' app will expose the endpoint (/pets/1)
Access mashling service (service3) behind the proxy as
> curl -v $(docker-machine ip default):8000/pets/1


### Deploy an existing mashling binary in Envoy front-proxy
#### Command
	$jdoe-machine:front-proxy jdoe$ pwd
	/Users/jdoe/front-proxy
	
	$jdoe-machine:front-proxy jdoe$ ./setupEnvoyFrontProxy.sh

This will prompt for the following user inputs:

1. Name of the mashling app (default is sample-mashling-app)
2. Path of the mashling app folder (default is ./gateway/sample)

Please note that the default mashling app is available under the ./gateway/sample folder in the source.

The 'sample-mashling-app' app will expose the endpoint (/pets/1)
Access mashling service (service3) behind the proxy as
> curl -v $(docker-machine ip default):8000/pets/1


If the user provides name and path inputs then the script will check if a binary with the given name exists in the <path>/bin folder. If one does not exist, the script will terminate.

Using this script, you can deploy an existing mashling app into the Envoy front-proxy. 

### Changes in the Envoy front-proxy for a non-sample mashling app

Please make sure that the mashling-envoy.json file reflects the HTTP filter routes corresponding to your mashling API endpoint. The default app exposes '/pets/:petId' on port 9096.

The front-envoy.json file should be changed accordingly to keep APIs consistently documented. The default app is configured with the front-envoy.json given the '/pets' prefix.

### Test directly using docker-compose

You can also get the envoy mesh up and running with docker-compose directly.

> docker-machine create --driver virtualbox default

> eval $(docker-machine env default) 

> echo "MASHLING_NAME=sample" > .env
> 
> env $(cat .env | xargs) docker-compose up --build -d

> docker-compose ps

> 		Name                		State     Ports     
>---                
>		frontproxy_front-envoy_1     Up       0.0.0.0:8000->80/tcp, 0.0.0.0:8001->8001/tcp 
>		frontproxy_service1_1        Up       80/tcp                                       
>		frontproxy_service2_1        Up       80/tcp                                       
>		frontproxy_service3_1        Up       80/tcp       

Access service1 as
> curl -v $(docker-machine ip default):8000/service/1

Access mashling service (service3) behind the proxy as
> curl -v $(docker-machine ip default):8000/pets/1
 

## Adding a new mashling app into the mesh

Mashling is an event-driven microgateway application that that can work with a variety of triggers such as REST, KAFKA and MQTT etc. For more info on mashling [see](https://github.com/TIBCOSoftware/mashling-cli)

Mashling apps can consume events such as REST endpoint invocation or a message delivered on a KAFKA topic. As a result, deploying a mashling app into the L7 proxy framework such as Lyft/Envoy needs some configuration.

### Mashling microgateway app using an HTTP trigger
A mashling microgateway app that uses an HTTP trigger can, potentially, expose multiple rest endpoint routes that front different backend microservices.

When such mashling app is deployed on Envoy front-proxy service mesh, we need to consider each rest endpoint exposed by the mashling app and decide whether it needs to be exposed through the envoy front-proxy. If we decide to expose a rest endpoint through envoy front-proxy, we need to create/change the following code artifacts:

1. Make a copy of the mashling-envoy.json. The new file is, e.g., acme-mashling-envoy.json
2. Change the routes configuration in the acme-mashling-envoy.json file according to the rest endpoint(s) that your mashling microgateway exposes.

		   "route_config": {
              "virtual_hosts": [
                {
                  "name": "service",
                  "domains": ["*"],
                  "routes": [
                    {
                      "timeout_ms": 0,
                      "prefix": "/pets",
                      "cluster": "local_service"
                    }
                  ]
                }
              ]
            },


3. Change the cluster information section in the acme-mashling-envoy.json according to the ports your service endpoints work with.
	
		"cluster_manager": {
		    "clusters": [
		      {
		        "name": "**local_service**",
		        "connect_timeout_ms": 250,
		        "type": "strict_dns",
		        "lb_type": "round_robin",
		        "hosts": [
		          {
		            "url": "tcp://127.0.0.1:9096"
		          }
		        ]
		      }
	    ]
	  }
4. Open the front-envoy.json file and add your new service routes alongside the other routes 
		              
		"virtual_hosts": [
        {
              "name": "backend",
              "domains": ["*"],
              "routes": [
                {
                  "timeout_ms": 0,
                  "prefix": "/service/1",
                  "cluster": "service1"
                },
                {
                  "timeout_ms": 0,
                  "prefix": "/service/2",
                  "cluster": "service2"
                },
                {
                  "timeout_ms": 0,
                  "prefix": "/pets",
                  "cluster": "service3"
                }
              ]
            }
          ]
        },
5. Also add your cluster in the cluster manager section in the front-envoy.json 

			  "cluster_manager": {
			    "clusters": [
			      {
			        "name": "service1",
			        "connect_timeout_ms": 250,
			        "type": "strict_dns",
			        "lb_type": "round_robin",
			        "features": "http2",
			        "hosts": [
			          {
			            "url": "tcp://service1:80"
			          }
			        ]
			      },
			      {
			        "name": "service2",
			        "connect_timeout_ms": 250,
			        "type": "strict_dns",
			        "lb_type": "round_robin",
			        "features": "http2",
			        "hosts": [
			          {
			            "url": "tcp://service2:80"
			          }
			        ]
			      },
			      {
			        "name": "service3",
			        "connect_timeout_ms": 250,
			        "type": "strict_dns",
			        "lb_type": "round_robin",
			        "hosts": [
			          {
			            "url": "tcp://service3:80"
			          }
			        ]
			      }
			    ]
			  }

6. Add the new service entry in the docker-compose.yml. Use acme-mashling-envoy.json in mounting the file volume. Make other relevant changes fofr alias, env variable etc.

		  service3:
		    build:
		      context: .
		      args:
		        - MASHLING_NAME
		      dockerfile: Dockerfile-mashling
		    volumes:
		      - ./mashling-envoy.json:/etc/service-envoy.json
		    networks:
		      envoymesh:
		        aliases:
		          - service3
		    environment:
		      - SERVICE_NAME=3
		    expose:
		      - "80"

7. Run **docker-compose up --build -d** to spin up new sandbox with your service running as a member of the envoymesh.
8. That's it! 
 

## License
mashling is licensed under a BSD-type license. See TIBCO LICENSE.txt for license text.

lyft/envoy is licenced under Apache-2.0 license.