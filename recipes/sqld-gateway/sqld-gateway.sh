#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 )
    echo "${my_list[@]}"
}

#Run gateway payload without sql injection attack
function testcase1 {
mashling-gateway -c sqld-gateway.json > /tmp/sqld1.log 2>&1 &
pId=$!
sleep 5
response=$(curl http://localhost:9096/pets --upload-file payload.json --write-out '%{http_code}' --silent --output /dev/null)
if [ $response -eq 200  ] && [[ "echo $(cat /tmp/sqld1.log)" =~ "Code identified in response output: 200" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
kill -9 $pId
}

#Run gateway payload sql injection attack
function testcase2 {
mashling-gateway -c sqld-gateway.json > /tmp/sqld2.log 2>&1 &
pId=$!
sleep 5
response=$(curl http://localhost:9096/pets --upload-file attack-payload.json --write-out '%{http_code}' --silent --output /dev/null)
if [ $response -eq 403  ] && [[ "echo $(cat /tmp/sqld2.log)" =~ "Code identified in response output: 403" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
kill -9 $pId
}