#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {

$GOPATH/src/github.com/TIBCOSoftware/mashling/bin/mashling-gateway -c mqtt-producer.json > /tmp/gw1.log 2>&1 &
pId=$!
echo "$pId"
#starting mosquitto_sub in background and copying logs into temp file
mosquitto_sub -t "test" > /tmp/test.log & pId1=$!
sleep 5
curl -d "{\"message\": \"hello-world\"}" http://localhost:9096/test
sleep 5
var=$(cat /tmp/test.log)
echo $var

#killing process
kill -9 $pId
kill -9 $pId1

if [[ "$var" == "{\"message\":\"hello-world\"}" ]] && [[ "echo $(cat /tmp/gw1.log)" =~ "Completed" ]]
        then 
            echo "PASS"
            
        else
            echo "FAIL"
            
    fi
	rm -f /tmp/test1.log	
}