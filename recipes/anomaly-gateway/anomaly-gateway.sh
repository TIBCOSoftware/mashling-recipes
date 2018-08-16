#!/bin//bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}

function testcase1 {
mashling-gateway -c anomaly-gateway.json > /tmp/anomaly1.log 2>&1 &
pId=$!
sleep 5
go run main.go -server > /tmp/server.log 2>&1 & 
pId1=$!
sleep 5
go run main.go -client > /tmp/client.log 2>&1 
sleep 20
response=$(curl http://localhost:9096/test --upload-file anomaly-payload.json --write-out '%{http_code}' --silent --output /dev/null)
response=$(curl http://localhost:9096/test --upload-file anomaly-payload.json --write-out '%{http_code}' --silent --output /dev/null)
if [ $response -eq 200 ] && [[ "echo $(cat /tmp/client.log)" =~ "number of anomalies 0" ]] 
    then
        echo "PASS"
    else
        echo "FAIL"
fi  
kill -9 $pId
kill $(lsof -t -i:1234)
}