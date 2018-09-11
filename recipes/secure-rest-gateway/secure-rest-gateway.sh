#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {
	
	mkdir -p $HOME/gatewaycerts $HOME/truststore
	cp $GOPATH/src/github.com/TIBCOSoftware/mashling-recipes/recipes/secure-rest-gateway/utils/gateway.crt $HOME/gatewaycerts
	cp $GOPATH/src/github.com/TIBCOSoftware/mashling-recipes/recipes/secure-rest-gateway/utils/gateway.key	 $HOME/gatewaycerts
	cp $GOPATH/src/github.com/TIBCOSoftware/mashling-recipes/recipes/secure-rest-gateway/utils/client.crt $HOME/truststore
	cp $GOPATH/src/github.com/TIBCOSoftware/mashling-recipes/recipes/secure-rest-gateway/utils/apiserver.crt $HOME/truststore
	
	export SERVER_CERT=$HOME/gatewaycerts/gateway.crt
	export SERVER_KEY=$HOME/gatewaycerts/gateway.key
	export TRUST_STORE=$HOME/truststore
	export ENDPOINT_URL=https://localhost:8080
	echo $ENDPOINT_URL $SERVER_CERT $SERVER_KEY $TRUST_STORE
	
	# chmod 777 secure-rest-gateway
	mashling-gateway -c secure-rest-gateway.json > /tmp/gw.log 2>&1 &  pId2=$!
	echo $pId2
	
	go get -u github.com/levigross/go-mutual-tls/...
	
	pushd $GOPATH/src/github.com/levigross/go-mutual-tls
	cp -r $GOPATH/src/github.com/TIBCOSoftware/mashling-recipes/recipes/secure-rest-gateway/utils/* $GOPATH/src/github.com/levigross/go-mutual-tls
	cd client
	sed -i s/'cert, err := tls.LoadX509KeyPair("..\/cert.pem", "..\/key.pem")/cert, err := tls.LoadX509KeyPair("..\/client.crt", "..\/client.key")'/g client.go
	sed -i s/'clientCACert, err := ioutil.ReadFile("..\/cert.pem")/clientCACert, err := ioutil.ReadFile("..\/gateway.crt")'/g client.go
	sed -i s/'resp, err := grequests.Get("https:\/\/localhost:8080", ro)/resp, err := grequests.Get("https:\/\/localhost:9098\/pets\/25", ro)'/g client.go

	cd ../server
	sed -i s/'fmt.Fprintf(w, "Hello %v! \\n", req.TLS.PeerCertificates\[0].EmailAddresses\[0])/w.Header().Set("Content-Type", "application\/json")\nw.Write(\[]byte(`{"Hobbies":\["snowboarding","programming"],"Name":"Alex"}`))'/g server.go
	sed -i s/'certBytes, err := ioutil.ReadFile("..\/cert.pem")/certBytes, err := ioutil.ReadFile("..\/gateway.crt")'/g server.go
	sed -i s/'CipherSuites: \[]uint16{tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384},/CipherSuites: \[]uint16{tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256},'/g server.go
	sed -i s/'log.Println(httpServer.ListenAndServeTLS("..\/cert.pem", "..\/key.pem"))/log.Println(httpServer.ListenAndServeTLS("..\/apiserver.crt", "..\/apiserver.key"))'/g server.go
	sed -i s/'"fmt"/\/\/"fmt"'/g server.go
	
	go run server.go > /tmp/server.log & pId=$!
	cd ../client
	sleep 20
	# go run client.go > /tmp/client.log 'sleep 5' & pId1=$!
	go run client.go 1> /tmp/client.log 2>&1
	#output=$(cat /tmp/client.log)
	input="{"Hobbies":["snowboarding","programming"],"Name":"Alex"}"
	#output=Hobbies
	
	if [[ "echo $(cat /tmp/client.log)" =~ "snowboarding" ]] && [[ "echo $(cat /tmp/gw.log)" =~ "Completed" ]]
        then 
            echo "PASS"
            
        else
            echo "FAIL"
            
    fi	
	popd
	
	# rm -f /tmp/client.log /tmp/gw.log
	# kill -9 $pId
	var=$(ps --ppid $pId)
	pId7=$(echo $var | awk '{print $5}')
	kill -9 $pId7
	kill -9 $pId2
	
}
