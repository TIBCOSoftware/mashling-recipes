# Running Mashling on Kubernetes
This recipe will walk you through creating a Docker image out of your Mashling gateway and creating the files needed to deploy to Kubernetes.

## Prerequisites
For this scenario to work you'll need the following prerequisites installed:
* Docker (and an account for Docker Hub)
* A Kubernetes environment (for example minikube)
* The Mashling CLI

### Docker
For this scenario we'll make use of [Docker Hub](https://hub.docker.com) to push the images to so that the Kubernetes cluster can access them. To make sure you can push your images to Docker Hub you'll need to:
* Register at [Docker Hub](https://hub.docker.com/), which is free
* Log in from your terminal so the Docker client knows where to push images to using `docker login`

_Note that while this scenario uses Docker Hub, you can also leverage other container registries, including private ones, as long as your Kubernetes cluster is able to connect to it_

### Minikube
If you haven’t set up your own Kubernetes cluster yet, you might want to look at [minikube](https://github.com/kubernetes/minikube). The team has made an amazing effort to make it super easy to run your own cluster locally with minimal installation effort. The [readme](https://github.com/kubernetes/minikube/blob/master/README.md) is an excellent place to get started, including installing your own Kubernetes cluster. In this scenario we'll use a few minikube commands:
* `minikube start` -> Start your minikube cluster
* `minikube ip` -> Get the public IP address of your cluster

_All commands are very well documented on the minikube repos_

### Mashling CLI
To install the Mashling CLI run `go get -u github.com/TIBCOSoftware/mashling/...`. This will install the latest version of the CLI on your machine, including any updates to the underlying dependencies (like [Project Flogo](https://github.com/TIBCOSoftware/flogo))

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
To build a gateway from this recipe that can run in an `alpine` docker container on Kubernetes we need to compile the gateway to work with linux. To do that, you'll need to add `env GOOS=linux` to your command to instruct the compiler to build for Linux operating systems:
```
$ cd gateway
$ env GOOS=linux mashling build
```
This command will create an executable called `gateway-linux-amd64` and will also create a bin folder.

## Creating a Docker image
Now that the executable is built, you can create a Docker image using `alpine` to keep the size of the app as low as possible. To do that copy the `Dockerfile` to the bin directory and execute
```
## Build image
$ docker build . -t <your username>/gateway-app
```
To make your image available on Docker Hub you can execute the below command. Just be sure that you're logged in to your Docker Hub account using the `docker login` command.
```
## Push to hub.docker.com
$ docker push <your username>/gateway-app:latest
```

## Intermezzo
Awesome! You just created a Docker images from your gateway and you could run it as a Docker image as well. To do that we'll also need to have a few apps that will return some data to you. For this scenario you can make use of [TIBCO Cloud Integration](https://cloud.tibco.com) to create mock apps. The source code in this repo contains two Swagger files:
* SwaggerFileAppOne.json
* SwaggerFileAppTwo.json

You can import these Swagger files in the API Modeler of TIBCO Cloud Integration:
* Click on **API Specs** in the main menu of TIBCO Cloud Integration
* Click on the upload icon
* Select both Swagger files

After that you can use them to create mock apps. To do that move the mouse pointer over an API specification and click > Create Mock app. After you've created the mock apps you can get the URLs for them by clicking on `View and Test 1 Endpoint` and selecting `copy`. These are the endpoints that we'll use later on as well for `<URL1>` and `<URL2>`. The two Swagger files contain path parameters (`{name}`), to make sure the Mashling understand it should take that as a parameter as well you'll need to add `:id` at the end of the copied URL. The `id` is referenced in gateway.json (line [59](./gateway.json#L59) and [73](../gateway.json#L59)) where it substitutes the parameter for the actual value you supplied.

As an example:

**URL you have copied**

`https://integration.cloud.tibcoapps.com:443/<uuid>/greeting`  

**URL you need to use**

`https://integration.cloud.tibcoapps.com:443/<uuid>/greeting/:id`


To run your Mashling gateway as a docker container, you can use the `docker run` command:
```
$ docker run --env HELLO_API_ENDPOINT=<URL1> --env BYE_API_ENDPOINT=<URL2> -p 9096:9096 <your username>/gateway-app
```

## Kubernetes
Right, and now back to Kubernetes! To run the gateway on K8s you need to create a deployment and a service (the latter exposes the Mashling app to the outside world). You can build them yourself or you can use the accompanying kube-deployment and kube-service files. If you do use the provided files, please make sure to change the variables for the Docker image and the URLs in kube-deployment. After that, execute:
```
## Start minikube if you haven't done that yet, or skip this step if you're not using minikube
minikube start

## Create K8s deployment
kubectl apply -f kube-deployment.yml

## Create K8s service
kubectl apply -f kube-service.yml
```
_Note that you do need to have your Kubernetes cluster running for this to work. If you haven't installed a Kubernetes cluster yet, you can check the prerequisites section for instructions for minikube_

## Testing
You can now test the gateway app by simply executing a cURL command:
```
$ curl http://<K8s external IP>:30061/hello/world
```

If you're using minikube to follow along this scenario you can get the external IP address by running
```
$ minikube ip
```

## Changing the URLs after deployment
If you want to change the URLs after you deployed your Mashling to Kubernetes you can simply edit the deployment and make changes to the environment variables.
```
$ kubectl edit deployment/gwdeployment
```
