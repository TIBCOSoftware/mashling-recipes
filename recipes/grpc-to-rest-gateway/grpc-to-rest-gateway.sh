#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 testcase3 )
    echo "${my_list[@]}"
}

#PetById method
function testcase1 {
mkdir -p $GOPATH/src/grpc-to-rest-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-rest-gateway/petstore/
./mashling-gateway -c grpc-to-rest-gateway.json > /tmp/grpc1.log 2>&1 &
pId2=$!
sleep 5
go run main.go -client -port 9096 -method pet -param 2 > /tmp/client1.log 2>&1 
sleep 5
if [[ "echo $(cat /tmp/client1.log)" =~ "res : pet:<id:2" ]] && [[ "echo $(cat /tmp/grpc1.log)" =~ "Completed" ]]
    then
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
}

#UserByName method
function testcase2 {
mkdir -p $GOPATH/src/grpc-to-rest-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-rest-gateway/petstore/    
./mashling-gateway -c grpc-to-rest-gateway.json > /tmp/grpc2.log 2>&1 &
pId2=$!
sleep 5
go run main.go -client -port 9096 -method user -param user1 > /tmp/client2.log 2>&1 
sleep 5
if [[ "echo $(cat /tmp/client2.log)" =~ "res : user:" ]] && [[ "echo $(cat /tmp/grpc2.log)" =~ "Completed" ]]
    then
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
}

#PetPUT method
function testcase3 {
mkdir -p $GOPATH/src/grpc-to-rest-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-rest-gateway/petstore/
./mashling-gateway -c grpc-to-rest-gateway.json > /tmp/grpc3.log 2>&1 &
pId2=$!
sleep 5
go run main.go -client -port 9096 -method petput -param 2,testpet > /tmp/client3.log 2>&1 
sleep 5
if [[ "echo $(cat /tmp/client3.log)" =~ "res : pet:<id:2 name" ]] && [[ "echo $(cat /tmp/grpc3.log)" =~ "Completed" ]]
    then
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
}