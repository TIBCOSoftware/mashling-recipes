# HA Kubernetes recipe with consul service discovery
This recipe deployes Mashling gateway application into Kubernetes cluster, ensures high availability & registres services with Consul for service discovery

Pictorial representation of the recipe solution:
![Screenshot](images/HA-RECIPE.jpg)

Note: kubernetes environment is simulated using kubeadm-dind cluster with 3 nodes. kubeadm-dind-cluster supports k8s versions 1.8.x, 1.9.x and 1.10.x.<br>


![Kubernetes nodes](images/nodes.jpg)

### Prerequisites
Following prerequisites needs to be installed:
* Docker 
* Install [kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-using-native-package-management)
* Download [consul](https://www.consul.io/downloads.html) binary and update PATH environment variable to include consul binary.
* Install md5sha1sum for mac
```
brew install md5sha1sum
```
* Install wget and watch
```
# linux
$ sudo apt-get install wget
$ sudo apt-get install watch

# mac
$ brew install wget --with-libressl
$ brew install watch
```

### Preparing the gateway
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/ha-kubernetes-consul
```
* Download the Mashling-Gateway Linux Binary from [Mashling-releases](https://github.com/TIBCOSoftware/mashling/releases). 

### Setup
#### 1. Consul setup
Command to run consul agent with the directory containing configuration json file.
```
$ consul agent -dev -client <HOSTIP> -config-dir config-files
```
HOSTIP : Provide IP of the local machine <br>

#### 2. mashling app deployment on kubernetes
Deployment of mashling app on kubernetes cluster can be done in one step using bash file.

```
chmod ugo+x *.sh
./kubernetes-setup.sh <CONSUL-HOST-IP> b1gs33cr3t
```
CONSUL-HOST-IP: Provide HOST IP used for starting consul agent.

Note : Once the setup is complete restart kubernetes dashboard by running below command <br>
```
kubectl get pods -n kube-system
kubectl delete pod -n kube-system <Kubernetes-dashboard-podname>
```
Note: Replace 1.8 with 1.9 or 1.10 to use other Kubernetes versions for kubeadm dind cluster in kubernetes-setup bash file.<br>
If kubernetes cluster is running on cloud or on-prem, replace the content in register-consul bash file
```
"$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }')" 
with 
"$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="ExternalIP")].address }')"
```


### Consul dashboard
Access consul dashboard on browser
```
http://<HOSTIP>:8500/ui
```
Navigate to setting and update the consul token. 

Consul dashboard view 

![view](images/consul.jpg)

### Testing 
#1 You can now test the gateway app by simply executing a cURL command: <br>

```
$ curl http://<K8s external IP>:30061/pets/1
```
Note: To get Kuberentes cluster IP address run below command and choose any of the obtained IP's.
```
kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'
``` 
Response 
```
{
 "category": {
  "id": 1001,
  "name": "Animal"
 },
 "id": 1,
 "name": "as",
 "photoUrls": [
  "img/test/dog.jpeg",
  "img/test/dog1.jpeg"
 ],
 "status": "bv",
 "tags": [
  {
   "id": 2001,
   "name": "Pet"
  },
  {
   "id": 2002,
   "name": "Animal"
  }
 ]
}
```

#2 For Testing Horizontal Pod Autoscaler, increase the load on the endpoint.

```
$ while true;do curl http://<K8s external IP>:30061/pets/1 ; done
```

![mashling-hpa](images/mashling-hpa.jpg)

Open new terminal and execute the HPA service as cron using below command. 
```
$ kubectl get hpa --watch
```

![screnshot](images/HA-Log.jpg)

### Access kubernetes and grafana dashboard

To access dashboards run
```
$ kubectl cluster-info
```
![cluster-info](images/info.jpg)


Access Grafana dashboard in the browser

![dashborad](images/grafana-dashboard.jpg)