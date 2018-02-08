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
    popd
	
    #executing the gateway binary
    ./resttrigger-to-kafkapublisher  1> /tmp/output.log 2>&1 &  
    pId3=$!
    sleep 20

    cd $GOPATH/kafka
	
	curl -X PUT "http://localhost:9096/petEvent" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"category": {"id": 16,"name": "Animals"},"id": 16,"name": "SPARROW","photoUrls": ["string"],"status": "sold","tags": [{	"id": 0,"name": "string"}]}'	 
	
    bin/kafka-console-consumer.sh --topic syslog --bootstrap-server localhost:9092 --from-beginning  1> /tmp/tmp.log 2>&1 & pId4=$!  
    sleep 20
	if [[ "echo $(cat /tmp/tmp.log)" =~ '{"category":{"id":16,"name":"Animals"},"id":16,"name":"SPARROW","photoUrls":["string"],"status":"sold","tags":[{"id":0,"name":"string"}]}' ]] && [[ "echo $(cat /tmp/output.log)" =~ '{"category":{"id":16,"name":"Animals"},"id":16,"name":"SPARROW","photoUrls":["string"],"status":"sold","tags":[{"id":0,"name":"string"}]}' ]] ;
        then 
            echo "PASS"
            
        else
            echo "FAIL"
            
    fi
    kill -SIGINT $pId3
    sleep 5
    kill -SIGINT $pId
    sleep 5
    kill -SIGINT $pId1
    sleep 5
    kill -SIGINT $pId4
    rm -f /tmp/test.log /tmp/kafka.log
	cd C:/Users/lmekala/Desktop/Info/mashling-recipes/recipes/RestTrigger-To-KafkaPublisher/gw/bin
}
