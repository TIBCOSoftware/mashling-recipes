# Publish to Mashery Recipe

This is a recipe to publish the HTTP triggers in the gateway json file into Mashery.

Instructions:

1) Create the Mashery configuration file. Now, you can create the file and specify it via a switch (-creds <FILE>) or you can create a dot file with with the path <HOME>/.mashery.conf. The file should contain:

ApiKey=xxxyyyzzz
ApiSecret=aaabbbccc
Username=someuser
Password=somepassword
AreaDomain=somedomain.example.com
AreaId=xxxyyyzzz
PublicHost=somewhere.example.com
IoDocs=false
TestPlan=false

The AreaDomain is a fully qualified domain name for a public endpoint (i.e. Traffic Manager). The fully qualified domain name should be something like "foobar.api.mashery.com".

2) Place the rest-conditional-gateway.json in a folder and publish to Mashery using the command below:

If using the dot file <HOME>/.mashery.conf:
```bash
mashling publish -configFile rest-conditional-gateway.json
```

If not using the dot file:
```bash
mashling publish -configFile rest-conditional-gateway.json -creds /path/to/mashery/file
```

For more details about the various switches, run:

```bash
mashling help publish
```

