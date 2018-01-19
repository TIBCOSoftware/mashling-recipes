# Running Mashling on Kubernetes
This recipe will walk you through creating a Docker image out of your Mashling gateway and creating the files needed to deploy to Kubernetes.

## Prerequisites
For this scenario to work you'll need the following prerequisites installed:
* Docker (and an account for Docker Hub)
* A Kubernetes environment (for example minikube)
* The Mashling CLI

## Preparing the gateway
The gateway for this scenario is based on the [tunable-rest-gateway](https://github.com/TIBCOSoftware/mashling-recipes/tree/master/recipes/tunable-rest-gateway), but there are a few key differences:
* There are two triggers, each with their own path 
* There is one common event handler, used by both triggers
* There are two event links that link the triggers to the event handler
* Both event links make use of an environment variable to specify the endpoint (for example `${env.HELLO_API_ENDPOINT}`)

To create the folder structure and download the required files, execute:
```
$ mashling create -f gateway.json gateway
```

## Building the gateway
To build a gateway from this recipe that can run in an `alpine` docker container on Kubernetes we need to compile the gateway to work with linux:
```
$ cd gateway
$ env GOOS=linux mashling build
```
This command will create an executable called `gateway-linux-amd64` and will also create a bin folder.

## Creating a Docker image
Now that the executable is built, you can create a Docker image using `alpine` to keep the size of the app as low as possible. To do that copy the `Dockerfile` to the bin directory and execute
```
## Build image
docker build . -t <your username>/gateway-app

## Push to hub.docker.com
docker push <your username>/gateway-app:latest
```

## Intermezzo
Awesome! You just created a Docker images from your gateway and you could run it as a Docker image as well. To do that, you can use the `docker run` command:
```
$ ## Run
docker run --env HELLO_API_ENDPOINT=<URL1> --env BYE_API_ENDPOINT=<URL2> -p 9096:9096 <your username>/gateway-app
```
To spin up a few mock apps, you can make use of [TIBCO Cloud Integration](https://cloud.tibco.com) and import the two Swagger files and create Mock apps out of them

## Kubernetes
Right, and now back to Kubernetes! To run the gateway on K8s you need to create a `deployment` and a `service` (the latter exposes the Mashling app to the outside world). You can use the accompanying `kube-deployment` and `kube-service` files, though make sure you change the variables for the Docker image and the URLs. After that, execute:
```
## Create K8s deployment
kubectl apply -f kube-deployment.yml

## Create K8s service
kubectl apply -f kube-service.yml
```

## Testing
You can now test the gateway app by simply executing a cURL command:
```
$ curl --request http://<K8s>:30061/hello/world
```
_note: you'll need to use the external IP address of your Kubernetes cluster_

## Changing the URLs after deployment
If you want to change the URLs after you deployed your Mashling to Kubernetes you can simply edit the deployment and make changes to the environment variables.
```
$ kubectl edit deployment/gwdeployment
```
