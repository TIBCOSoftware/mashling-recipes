#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 testcase2 )
    echo "${my_list[@]}"
}
function testcase1 {
./rest-conditional-gateway &
pId=$!
response=$(curl --request GET http://localhost:9096/pets/24 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] 
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}
function testcase2 {
./rest-conditional-gateway &
pId=$!
response=$(curl -X PUT "http://localhost:9096/pets" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"category":{"id":16,"name":"Animals"},"id":16,"name":"SPARROW","photoUrls":["string"],"status":"sold","tags":[{"id":0,"name":"string"}]}' --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] 
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}