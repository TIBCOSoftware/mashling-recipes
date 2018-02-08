#!/bin/babat

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {

    pushd $GOPATH/kafka
    # starting zookeeper in background
    bin/zookeeper-server-start.sh config/zookeeper.properties > /tmp/kafka.log &
    pId=$!
    sleep 10

    # starting kafka server in background
    bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log &
    pId1=$!
    sleep 10

    # creating kafka topic
    bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic users &
    pId2=$!
    sleep 10

    popd
	
    #executing the gateway binary
    ./event-dispatcher-router-mashling 1> /tmp/test.log 2>&1 &
    pId4=$!
    sleep 20

    pushd $GOPATH/kafka
    current_time=$(date "+%Y.%m.%d-%H.%M.%S")

    #passing message from kafka producer
    output="{\"id\":15,\"country\":\"USA\",\"category\":{\"id\":0,\"name\":\"string\"},\"name\":\"doggie\",\"photoUrls\":[\"string\"],\"tags\":[{\"id\":0,\"name\":\"string\"}],\"status\":\"available\"}"
	echo "$output" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic users &  pId3=$!    
    sleep 2
	
	
    kill -SIGINT $pId1
    sleep 5
    kill -SIGINT $pId
    sleep 5
    kill -SIGINT $pId4
    sleep 5
    kill -SIGINT $pId5
    

    if [[ "echo $(cat /tmp/test.log)" =~ '{"id":15,"country":"USA","category":{"id":0,"name":"string"},"name":"doggie","photoUrls":["string"],"tags":[{"id":0,"name":"string"}],"status":"available"}' ]]; 
        then 
            echo "PASS"   
        else
            echo "FAIL"
    fi
    rm -f /tmp/test.log /tmp/kafka.log
	popd
}
