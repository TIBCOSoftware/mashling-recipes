#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 testcase2 testcase3 )
    echo "${my_list[@]}"
}
function testcase1 {

cat > $GOPATH/pswd.txt <<EOL
foo:bar
tom:jerry
EOL

export BASIC_AUTH_FILE=$GOPATH/pswd.txt	
mashling-gateway -c secure-rest-gateway-with-basic-auth.json > /tmp/gw1.log 2>&1 &
pId=$!
sleep 15
curl -X PUT "http://localhost:9096/pets" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"category":{"id":16,"name":"Animals"},"id":16,"name":"SPARROW","photoUrls":["string"],"status":"sold","tags":[{"id":0,"name":"string"}]}'
response=$(curl --request GET http://foo:bar@localhost:9096/pets/16 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] 
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}
function testcase2 {

cat > $GOPATH/pswd.txt <<EOL
foo:bar
tom:jerry
EOL

export BASIC_AUTH_FILE=$GOPATH/pswd.txt	

mashling-gateway -c secure-rest-gateway-with-basic-auth.json > /tmp/gw2.log 2>&1 &
pId=$!
sleep 15
response=$(curl --request GET http://foo:badpass@localhost:9096/pets/1 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 403  ] 
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}


function testcase3 {

cat > $GOPATH/pswd.txt <<EOL
foo:bar
tom:jerry
EOL

export BASIC_AUTH_FILE=$GOPATH/pswd.txt	

mashling-gateway -c secure-rest-gateway-with-basic-auth.json > /tmp/gw3.log 2>&1 &
pId=$!
sleep 15
response=$(curl --request GET http://tom:jerry@localhost:9096/pets/16 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] 
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}