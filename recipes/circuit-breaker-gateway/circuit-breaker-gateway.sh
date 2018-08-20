#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {
mashling-gateway -c circuit-breaker-gateway.json > /tmp/circuit1.log 2>&1 &
pId=$!
sleep 5
go run main.go -server &
pId1=$!
sleep 5
response=$(curl --request GET http://localhost:9096/pets/1 --write-out '%{http_code}' --silent --output /dev/null)
var=$(ps --ppid $pId1)
pId2=$(echo $var | awk '{print $5}')
kill -9 $pId2
for (( i=0; i<6;i++ ))
do
  curl http://localhost:9096/pets/1 > /tmp/test.log 2>&1 
  echo $i 
done
sleep 80
go run main.go -server &
pId3=$!
sleep 5
response1=$(curl --request GET http://localhost:9096/pets/1 --write-out '%{http_code}' --silent --output /dev/null)
if [ $response -eq 200 ] && [ $response1 -eq 200  ] && [[ "echo $(cat /tmp/circuit1.log)" =~ "Completed" ]] && [[ "echo $(cat /tmp/test.log)" =~ "circuit breaker tripped" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
kill -9 $pId
var=$(ps --ppid $pId3)
pId4=$(echo $var | awk '{print $5}')
kill -9 $pId4
sleep 10
}