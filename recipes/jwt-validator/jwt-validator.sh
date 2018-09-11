#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}

function testcase1 {
    mashling-gateway -c jwt-validator.json > /tmp/jwt1.log 2>&1 &
    pId=$!
    sleep 5
    ACCESS_TOKEN=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJtYXNoaWxuZyIsImlhdCI6MTUzNDIyNzgzOSwiZXhwIjoxNTY1NzYzODU0LCJhdWQiOiJ3d3cubWFzaGxpbmcuaW8iLCJzdWIiOiJqcm9ja2V0QGV4YW1wbGUuY29tIiwiaWQiOiI2In0.eCK8XHVNVzbasCAcyvYWs6gnkuZL9MzDm8-VY1-b-zg
    response=$(curl --request GET http://localhost:9096/pets -H "Authorization: Bearer $ACCESS_TOKEN"  --write-out '%{http_code}' --silent --output /dev/null)
    if [ $response -eq 200  ] && [[ "echo $(cat /tmp/jwt1.log)" =~ "200" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
    fi
    kill -9 $pId
}