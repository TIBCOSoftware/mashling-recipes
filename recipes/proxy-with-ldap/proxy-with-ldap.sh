#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 )
    echo "${my_list[@]}"
}

#pass xml as payload data
function testcase1 {
mkdir proxy-with-ldap
cp proxy-with-ldap.json proxy-with-ldap/
cp -r cert proxy-with-ldap/
cp key.pem proxy-with-ldap/
docker run -d -p 1234:389 pointlander/ldap
mashling-gateway -c proxy-with-ldap.json > /tmp/proxy1.log 2>&1 &
pId=$!
sleep 5
pushd target
go run main.go > /tmp/test.log 2>&1 &
pId1=$!
popd 
pushd proxy-with-ldap
response=$(curl -E cert/cert.pem -k --key key.pem -u john:johnldap -H "SOAPAction: test" -d '<xml>test</xml>'  https://localhost:9096/ --write-out '%{http_code}' --silent --output /dev/null)
if [ $response -eq 200  ] && [[ "echo $(cat /tmp/proxy1.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
popd
kill -9 $pId
kill -15 $pId1
docker kill $(docker ps -q)
}

#pass JSON as payload data
function testcase2 {
docker run -d -p 1234:389 pointlander/ldap
mashling-gateway -c proxy-with-ldap.json > /tmp/proxy1.log 2>&1 &
pId=$!
sleep 5
pushd target
go run main.go > /tmp/test.log 2>&1 &
pId1=$!
popd 
pushd proxy-with-ldap
response=$(curl -E cert/cert.pem -k --key key.pem -u john:johnldap -H "SOAPAction: test" -d '{"name":"test"}'  https://localhost:9096/ --write-out '%{http_code}' --silent --output /dev/null)
if [ $response -eq 200  ] && [[ "echo $(cat /tmp/proxy1.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
popd
kill -9 $pId
kill -15 $pId1
docker kill $(docker ps -q)
}