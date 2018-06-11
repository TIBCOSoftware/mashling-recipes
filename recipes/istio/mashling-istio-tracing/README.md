# Mashling with distributed tracing and Istio

This readme contains instructions for installing an example mashling into Istio.
The mashling has distributed tracing enabled and uses the Istio distributed tracing service.

## Installation
* Docker [docker](https://www.docker.com)
* Minikube [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
* Download the Mashling-Gateway Binary for Linux from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
### Install Istio on Kubernetes (minikube)
Follow [these instructions](https://istio.io/docs/setup/kubernetes/quick-start.html) with one slight change. After extracting Istio, edit install/kubernetes/istio.yaml. Uncomment the nodePort directive in the istio-ingress service controller:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: istio-ingress
  labels:
    istio: ingress
spec:
  type: LoadBalancer
  ports:
  - port: 80
#   nodePort: 32000
    name: http
  - port: 443
    name: https
  selector:
    istio: ingress
```

This will allow us to access our mashling service. If you haven't already, run:

```
minikube start
```

Continue with the Istio installation.

### Setup distributed tracing for Istio

Follow these [instructions](https://istio.io/docs/tasks/telemetry/distributed-tracing.html) to setup Zipkin distributed tracing.

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
kubectl create -f <(istioctl kube-inject -f deployment.yaml)
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

Wait ~5 minutes, and then execute the bellow with the address:

```
curl http://<minikube IP address>:32000/pets/1
```

Open your browser at http://localhost:9411 to see tracing.
