#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 testcase2 testcase3 testcase4 )
    echo "${my_list[@]}"
}

# Access gateway with token
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

# Access gateway with maxmium allowed times
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

# Accessing gateway without token
function testcase3 {
mashling-gateway -c rate-limiter-gateway.json > /tmp/rate3.log 2>&1 &
pId=$!
sleep 15
response=$(curl http://localhost:9096/pets/1 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 403  ] && [[ "echo $(cat /tmp/rate3.log)" =~ "Code identified in response output" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}

# Checking recovery time for ratelimiter
function testcase4 {
mashling-gateway -c rate-limiter-gateway.json > /tmp/rate4.log 2>&1 &
pId=$!
sleep 5
for (( i=0; i<3;i++ ))
do
  response=$(curl http://localhost:9096/pets/1 -H "Token:TOKEN1" --write-out '%{http_code}' --silent --output /dev/null) 
done
response1=$(curl http://localhost:9096/pets/1 -H "Token:TOKEN1" --write-out '%{http_code}' --silent --output /dev/null)
sleep 60
response2=$(curl http://localhost:9096/pets/1 -H "Token:TOKEN1" --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] && [ $response1 -eq 403  ] && [ $response2 -eq 200 ] && [[ "echo $(cat /tmp/rate4.log)" =~ "Code identified in response output" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}