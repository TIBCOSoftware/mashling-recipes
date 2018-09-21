#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 testcase2 )
    echo "${my_list[@]}"
}
function testcase1 {
mashling-gateway -c rate-limiter-gateway.json > /tmp/rate1.log 2>&1 &
pId=$!
sleep 15
response=$(curl http://localhost:9096/pets/1 -H "Token:TOKEN1" --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] && [[ "echo $(cat /tmp/rate1.log)" =~ "Code identified in response output" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}
function testcase2 {
mashling-gateway -c rate-limiter-gateway.json > /tmp/rate2.log 2>&1 &
pId=$!
sleep 15
for (( i=0; i<3;i++ ))
do
  response=$(curl http://localhost:9096/pets/1 -H "Token:TOKEN1" --write-out '%{http_code}' --silent --output /dev/null) 
done
response1=$(curl http://localhost:9096/pets/1 -H "Token:TOKEN1" --write-out '%{http_code}' --silent --output /dev/null)
response2=$(curl http://localhost:9096/pets/1 -H "Token:TOKEN2" --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] && [ $response1 -eq 403  ] && [ $response2 -eq 200  ] && [[ "echo $(cat /tmp/rate2.log)" =~ "Code identified in response output" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}