# Publish to Mashery Recipe

This is a recipe to publish the HTTP triggers in the gateway json file into Mashery.

Instructions:

1) Place the rest-conditional-gateway.json in a folder and create the app using the command below:

```bash
mashling publish -k KEY  -s SECRET_KEY -u USERNAME -p PASSWORD -uuid UUID -portal PORTAL_FULLY_QUALIFIED_DOMAIN_NAME -h HOST -f rest-conditional-gateway.json
```

The PORTAL_FULLY_QUALIFIED_DOMAIN_NAME is a fully qualified domain name for a public endpoint (i.e. Traffic Manager). The fully qualified domain name should be something like "foobar.api.mashery.com".

For more details about the various switches, run:

```bash
mashling help publish
```

