#!/bin/bash

#Pass consul ip as argument
HOSTIP=$1
CONSUL_TOKEN=$2

NODENAME=$(kubectl get nodes -o name)
#Get node ip address
if [[ $NODENAME == node/minikube ]]; then
    node=$(minikube ip) 
    echo Node ip : $node 
else
    NODES=$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }')
    for node in $NODES; do echo $node; done
    echo Node ip : $node
fi

#get services list
SERVICESLIST=$(echo $(kubectl get services -o name))
IFS=\        # space is set as delimiter
read -ra SERVICENAMESLIST <<< "$SERVICESLIST"    # str is read into an array as tokens separated by IFS
new_array=()
for value in "${SERVICENAMESLIST[@]}"
do
    [[ $value != service/kubernetes ]] && new_array+=($value)
done
SERVICENAME=("${new_array[@]}")
unset new_array
echo Total number of services-${#SERVICENAME[@]}
for ((k=0; k<"${#SERVICENAME[@]}"; k++));
    do
        SERVICE=$(echo ${SERVICENAME[$k]});
        SERVICE[$k]=${SERVICE:8}
        NODEPORTS=$(echo $(kubectl get -o jsonpath="{.spec.ports[*].nodePort}" services ${SERVICE[$k]}))
        echo  List of nodeports : $NODEPORTS 
        unset NODEPORT
        IFS=' '        # space is set as delimiter
        read -ra NODEPORT <<< "$NODEPORTS"    # str is read into an array as tokens separated by IFS
        for ((j=0; j<"${#NODEPORT[@]}"; j++));
            do
                response=$(curl -X PUT "http://$HOSTIP:8500/v1/agent/service/register" --header "X-Consul-Token: $CONSUL_TOKEN" -d '{"ID":"'"${SERVICE[$k]}-$j"'","Name":"'"${SERVICE[$k]}-$j"'","Tags":["primary","v1"],"Address":"'"$node"'","Port":'${NODEPORT[$j]}',"Meta":{"mashling_version":"0.4.0"},"EnableTagOverride":false,"Check":{"tcp":"'"$node"':'${NODEPORT[$j]}'","Interval":"10s"}}' --write-out '%{http_code}' --silent --output /dev/null)
                echo $response
            done    
    done
