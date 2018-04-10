#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {

$GOPATH/src/github.com/TIBCOSoftware/mashling/bin/mashling-gateway -c mqtt-gateway.json > /tmp/mqtt.log 2>&1 &
pId=$!
echo "$pId"
#starting mosquitto_sub in background and copying logs into temp file
mosquitto_sub -t "abc123" > /tmp/test.log & pId1=$!
mosquitto_pub -m "{\"id\":1,\"name\":\"SPARROW\",\"photoUrls\":[],\"tags\":[]}" -t "put"
sleep 5
mosquitto_pub -m "{\"pathParams\":{\"petId\":\"1\"},\"replyTo\":\"abc123\"}" -t "get"
sleep 5



#killing process
kill -9 $pId
kill -9 $pId1
var="photoUrls"
echo $var
if [[ "cat /tmp/test.log | grep $var" == *"$var"* ]] && [[ "echo $(cat /tmp/mqtt.log)" =~ "Completed" ]]
        then 
            echo "PASS"
            
        else
            echo "FAIL"
            
    fi
	rm -f /tmp/test1.log	
}