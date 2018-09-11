#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 testcase3 testcase4 )
    echo "${my_list[@]}"
}

function testcase1 {
mkdir -p $GOPATH/src/rest-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/rest-to-grpc-gateway/petstore/    
./mashling-gateway -c rest-to-grpc-gateway.json > /tmp/grpc1.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server1.log 2>&1 &
pId=$!
sleep 5
response=$(curl --request GET http://localhost:9096/petstore/PetById?id=2 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] && [[ "echo $(cat /tmp/grpc1.log)" =~ "Code identified in response output: 200" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
kill -9 $(lsof -t -i:9000)
}

function testcase2 {
mkdir -p $GOPATH/src/rest-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/rest-to-grpc-gateway/petstore/
./mashling-gateway -c rest-to-grpc-gateway.json > /tmp/grpc2.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server2.log 2>&1 &
pId=$!
sleep 5
response=$(curl --request GET http://localhost:9096/petstore/UserByName?username=user2 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] && [[ "echo $(cat /tmp/grpc2.log)" =~ "Code identified in response output: 200" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
kill -9 $(lsof -t -i:9000)
}

function testcase3 {
mkdir -p $GOPATH/src/rest-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/rest-to-grpc-gateway/petstore/    
./mashling-gateway -c rest-to-grpc-gateway.json > /tmp/grpc3.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server3.log 2>&1 &
pId=$!
sleep 5
response=$(curl -X PUT "http://localhost:9096/petstore/PetPUT" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"pet": {"id": 12,"name": "mycat12"}}' --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] && [[ "echo $(cat /tmp/grpc3.log)" =~ "Code identified in response output: 200" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
kill -9 $(lsof -t -i:9000)
}


function testcase4 {
mkdir -p $GOPATH/src/rest-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/rest-to-grpc-gateway/petstore/
./mashling-gateway -c rest-to-grpc-gateway.json > /tmp/grpc4.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server4.log 2>&1 &
pId=$!
sleep 5
curl --request GET http://localhost:9096/petstore/UserByName?username=user20 > /tmp/get4.log 2>&1
sleep 5
response=$(curl --request GET http://localhost:9096/petstore/UserByName?username=user30 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [[ "echo $(cat /tmp/get4.log)" =~ "rpc error: code = Unknown desc = User not found" ]] && [[ "echo $(cat /tmp/grpc4.log)" =~ "Code identified in response output: 404" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
kill -9 $(lsof -t -i:9000)
}