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
    bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic publishpet &
    pId2=$!
    sleep 10

    popd

    #executing the gateway binary
    mashling-gateway -c kafkatrigger-to-kafkapublisher.json > /tmp/kafka1.log &
    pId4=$!
    sleep 20

    cd $GOPATH/kafka
    current_time=$(date "+%Y.%m.%d-%H.%M.%S")

    #passing message from kafka producer
    echo "{\"country\":\"USA\",\"Current Time\" :\"$current_time\"}" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic publishpet &  pId3=$!    
    sleep 2

    # starting kafka consumer in background and capturing logged messages into tmp/test file
    bin/kafka-console-consumer.sh --topic subscribepet --bootstrap-server localhost:9092 --from-beginning > /tmp/test.log & pId5=$!
    sleep 10
	echo "kafka message value : [$(cat /tmp/test.log)]"	
    kafkaMessage=$(cat /tmp/test.log)

   echo $kafkaMessage;
    kill -SIGINT $pId1
    sleep 5
    kill -SIGINT $pId
    sleep 5
    kill -SIGINT $pId4
    sleep 5
    kill -SIGINT $pId5
    echo "{\"country\":\"USA\",\"Current Time\" :\"$current_time\"}"

    if [ "$kafkaMessage" == "{\"country\":\"USA\",\"Current Time\" :\"$current_time\"}" ] 
        then 
            echo "PASS"   
        else
            echo "FAIL"
    fi
    rm -f /tmp/test.log /tmp/kafka.log
}
