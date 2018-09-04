# Mashling with distributed tracing and Istio

This readme contains instructions for installing an example mashling into Istio.
The mashling has distributed tracing enabled and uses the Istio distributed tracing service.

## Installation
* Docker [docker](https://www.docker.com)
* Minikube [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
* Istio [istio](https://istio.io/docs/setup/kubernetes/download-release/)
* Download the Mashling-Gateway Binary for Linux from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
### Install Istio on Kubernetes (minikube)

Start minikube:
```
minikube start --memory=8192 --cpus=4 --kubernetes-version=v1.10.0
```

Follow [these instructions](https://istio.io/docs/setup/kubernetes/quick-start/) to install Istio. Use install 'Option 2'.

Verify everything is in the 'Running' or 'Completed' state. This may take some time:

```
kubectl get pods --all-namespaces
```

### Setup distributed tracing for Istio

Run the following to access Jaeger distributed tracing dashboard:
```
kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686 &
```

### Create a mashling

```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/istio/mashling-istio-tracing
```
Create a folder mashling and place the downloaded mashling-gateway and mashling.json in the folder
### Build a docker image

```
cp Dockerfile mashling
cp IstioTracing.json mashling
cd mashling
docker login
docker build -t <YOUR DOCKER USER>/mashling .
docker push <YOUR DOCKER USER>/mashling
```

### Deploy docker image to Kubernetes/Istio

```
cp ../deployment.yaml ./
```

Add your docker user to the deployment.yaml file:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: mashling
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: mashling
    spec:
      containers:
      - name: mashling
        image: docker.io/<YOUR DOCKER USER>/mashling
        ports:
        - containerPort: 9096
#      imagePullSecrets:
#      - name: regsecret
```

Deploy to Kubernetes/Istio:

```
kubectl label namespace default istio-injection=enabled
kubectl create -f deployment.yaml
```

Verify everything is in the 'Running' state. This may take some time:

```
kubectl get pods
```

## Testing
### Testing the mashling service

Get the minikube ip address:

```
minikube ip
```

Wait ~5 minutes, and then execute the below with the address:

```
curl http://<minikube IP address>:31380/pets/1
```

Open your browser at http://localhost:16686 to see tracing.
