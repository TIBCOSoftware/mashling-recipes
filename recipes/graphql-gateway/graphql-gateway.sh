#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {
export BASIC_AUTH_FILE=passwd.txt
mashling-gateway -c graphql-gateway.json > /tmp/graphql.log 2>&1 &
pId=$!
sleep 5
response=$(curl 'http://localhost:9096/graphql' -u foo:bar -H 'Content-Type: application/json' --data-binary '{"query":"{\n  products: allProducts(count: 3) {\n    id\n    name\n    price\n  }\n}","operationName":null}' --write-out '%{http_code}' --silent --output /dev/null)

kill -9 $pId

if [[ $response -eq 200 ]] && [[ "echo $(cat /tmp/graphql.log)" =~ "200" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}