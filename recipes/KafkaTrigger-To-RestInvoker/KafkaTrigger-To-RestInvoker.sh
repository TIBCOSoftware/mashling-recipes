#!/bin/bash

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
# KafkaTrigger to RestInvoker recipe
    bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic syslog &
    pId2=$!
    sleep 10
    popd

    #executing the gateway binary
    mashling-gateway -c KafkaTrigger-To-RestInvoker.json > /tmp/kafka1.log 2>&1 &
    pId4=$!
    sleep 20

    pushd $GOPATH/kafka

    #passing message from kafka producer
    echo "{\"category\":{\"id\":10,\"name\":\"string\"},\"id\":10,\"name\":\"doggie\",\"photoUrls\":[\"string\"],\"status\":\"available\",\"tags\":[{\"id\":0,\"name\":\"string\"}]}" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic syslog &  pId3=$!    
    sleep 2    
    curl --request GET http://petstore.swagger.io/v2/pet/10 > /tmp/kafkagw.log
    if [[ "echo $(cat /tmp/kafka1.log)" =~ "Completed" ]] && [[ "echo $(cat /tmp/kafkagw.log)" =~ "{\"id\":10,\"category\":{\"id\":10,\"name\":\"string\"},\"name\":\"doggie\",\"photoUrls\":[\"string\"],\"tags\":[{\"id\":0,\"name\":\"string\"}],\"status\":\"available\"}" ]] 
        then 
            echo "PASS"   
        else
            echo "FAIL"
    fi
    popd    
    kill -SIGINT $pId1
    sleep 5
    kill -SIGINT $pId
    sleep 5
    kill -SIGINT $pId4
    sleep 5
    kill -SIGINT $pId3
}
