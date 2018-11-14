#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 testcase3 )
    echo "${my_list[@]}"
}

# Run one client
function testcase1 {
go get github.com/gorilla/websocket
mashling-gateway -c proxy-websocket.json > /tmp/websocket1.log 2>&1 &
pId=$!
sleep 5
go run main.go -server > /tmp/server.log 2>&1 & 
pId1=$!
go run main.go -client -name=CLIENT -url=ws://localhost:9096/ws > /tmp/client1.log 2>&1 & pId2=$!
sleep 5
if [[ "echo $(cat /tmp/websocket1.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
kill -9 $pId
var=$(ps --ppid $pId1)
pId3=$(echo $var | awk '{print $5}')
kill -9 $pId3
}

# Run maximum+1 clients
function testcase2 {
mashling-gateway -c proxy-websocket.json > /tmp/websocket2.log 2>&1 &
pId=$!
sleep 5
go run main.go -server > /tmp/server2.log 2>&1 & 
pId1=$!
sleep 5
go run main.go -client -name=CLIENT1 -url=ws://localhost:9096/ws > /tmp/client1.log 2>&1 & pId2=$!
go run main.go -client -name=CLIENT2 -url=ws://localhost:9096/ws > /tmp/client2.log 2>&1 & pId3=$!
go run main.go -client -name=CLIENT3 -url=ws://localhost:9096/ws > /tmp/client3.log 2>&1 & 
sleep 5
if [[ "echo $(cat /tmp/websocket2.log)" =~ "Completed" ]] && [[ "echo $(cat /tmp/websocket2.log)" =~ "can't accept any more connections" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
kill -9 $pId
kill -SIGINT $pId2 $pId3
var=$(ps --ppid $pId1)
pId7=$(echo $var | awk '{print $5}')
kill -9 $pId7
}

# Run client without server
function testcase3 {
mashling-gateway -c proxy-websocket.json > /tmp/websocket3.log 2>&1 &
pId=$!
sleep 5
go run main.go -client -name=CLIENT1 -url=ws://localhost:9096/ws > /tmp/client1.log 2>&1
sleep 5
error="connection error: dial tcp 127.0.0.1:8080: connect: connection refused"
if [[ "echo $(cat /tmp/websocket3.log)" =~ "Completed" ]] && [[ "echo $(cat /tmp/websocket3.log)" =~ "$error" ]] && [[ "echo $(cat /tmp/client1.log)" =~ "failed to connect backend url" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
kill -9 $pId
}