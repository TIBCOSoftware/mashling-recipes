#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 testcase3 testcase4 testcase5 testcase6 )
    echo "${my_list[@]}"
}

# passing valid petId
function testcase1 {
mkdir -p $GOPATH/src/grpc-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-grpc-gateway/petstore/   
./mashling-gateway -c grpc-to-grpc-gateway.json > /tmp/grpc1.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server1.log 2>&1 &
pId=$!
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
var=$(ps --ppid $pId)
pId7=$(echo $var | awk '{print $5}')
kill -9 $pId7
}

# passing valid username
function testcase2 {
mkdir -p $GOPATH/src/grpc-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-grpc-gateway/petstore/
./mashling-gateway -c grpc-to-grpc-gateway.json > /tmp/grpc2.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server2.log 2>&1 &
pId=$!
sleep 5
go run main.go -client -port 9096 -method user -param user2 > /tmp/client2.log 2>&1 
sleep 5
if [[ "echo $(cat /tmp/client2.log)" =~ "res : user:<id:2 username" ]] && [[ "echo $(cat /tmp/grpc2.log)" =~ "Completed" ]]
    then
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
var=$(ps --ppid $pId)
pId7=$(echo $var | awk '{print $5}')
kill -9 $pId7
}

# passing invalid petId
function testcase3 {
mkdir -p $GOPATH/src/grpc-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-grpc-gateway/petstore/   
./mashling-gateway -c grpc-to-grpc-gateway.json > /tmp/grpc3.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server3.log 2>&1 &
pId=$!
sleep 5
go run main.go -client -port 9096 -method pet -param 21 > /tmp/client3.log 2>&1 
sleep 5
if [[ "echo $(cat /tmp/client3.log)" =~ "rpc error: code = Unknown desc = Pet not found" ]] && [[ "echo $(cat /tmp/grpc3.log)" =~ "Completed" ]]
    then
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
var=$(ps --ppid $pId)
pId7=$(echo $var | awk '{print $5}')
kill -9 $pId7
}

# passing invalid username
function testcase4 {
mkdir -p $GOPATH/src/grpc-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-grpc-gateway/petstore/
./mashling-gateway -c grpc-to-grpc-gateway.json > /tmp/grpc4.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server4.log 2>&1 &
pId=$!
sleep 5
go run main.go -client -port 9096 -method user -param user21 > /tmp/client4.log 2>&1
sleep 5
if [[ "echo $(cat /tmp/client4.log)" =~ "rpc error: code = Unknown desc = User not found" ]] && [[ "echo $(cat /tmp/grpc4.log)" =~ "Completed" ]]
    then
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
kill -9 $pId1
var=$(ps --ppid $pId)
pId7=$(echo $var | awk '{print $5}')
kill -9 $pId7
}

# removing params from the client
function testcase5 {
mkdir -p $GOPATH/src/grpc-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-grpc-gateway/petstore/   
./mashling-gateway -c grpc-to-grpc-gateway.json > /tmp/grpc5.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server5.log 2>&1 &
pId=$!
sleep 5
go run main.go -client -port 9096 -method pet > /tmp/client5.log 2>&1
sleep 5
if [[ "echo $(cat /tmp/client5.log)" =~ "rpc error: code = Unknown desc = Pet not found" ]] && [[ "echo $(cat /tmp/grpc5.log)" =~ "Completed" ]]
    then
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
var=$(ps --ppid $pId)
pId7=$(echo $var | awk '{print $5}')
kill -9 $pId7
}

# removing params from the client
function testcase6 {
mkdir -p $GOPATH/src/grpc-to-grpc-gateway/petstore
protoc -I . petstore.proto --go_out=plugins=grpc:$GOPATH/src/grpc-to-grpc-gateway/petstore/
./mashling-gateway -c grpc-to-grpc-gateway.json > /tmp/grpc6.log 2>&1 &
pId2=$!
sleep 5
go run main.go -server > /tmp/server6.log 2>&1 &
pId=$!
sleep 5
go run main.go -client -port 9096 -method user > /tmp/client6.log 2>&1
sleep 5
if [[ "echo $(cat /tmp/client6.log)" =~ "res : user:<id:2 username" ]] && [[ "echo $(cat /tmp/grpc6.log)" =~ "Completed" ]]
    then
        echo "PASS"
    else
        echo "FAIL"
fi        
kill -9 $pId2
var=$(ps --ppid $pId)
pId7=$(echo $var | awk '{print $5}')
kill -9 $pId7
}