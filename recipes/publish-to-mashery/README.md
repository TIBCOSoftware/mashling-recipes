# Publish to Mashery Recipe

This is a recipe to publish the HTTP triggers in the gateway json file into Mashery.

Instructions:

1) Place the rest-conditional-gateway.json in a folder and create the app using the command below:

```bash
mashling publish -k KEY  -s SECRET_KEY -u USERNAME -p PASSWORD -uuid UUID -portal PORTAL_URL -h HOST -f rest-conditional-gateway.json
```

For more details about the various switches, run:

```bash
mashling help publish
```

