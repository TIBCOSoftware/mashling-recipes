/opt/tibco/eftl/3.3/ftl/bin/tibrealmadmin --realmserver http://localhost:8080 \
	--updaterealm /opt/tibco/eftl/3.3/samples/tibrealmserver.json
/opt/tibco/eftl/3.3/bin/tibeftlserver --realmserver http://localhost:8080 \
	--listen ws://localhost:9191
