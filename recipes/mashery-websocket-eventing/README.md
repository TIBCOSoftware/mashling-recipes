# Mashery websocket log events analyzer
This recipe is a gateway opens a websocket connection to Mashery logs streaming service, parse each log message and triggers an email notification using [sendgrid.com](https://sendgrid.com) in case of an error log.

## Installation
* Download or build the mashling-gateway binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup

1. Download the recipe
```bash
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/mashery-websocket-eventing
```
2. Place the downloaded mashling-gateway binary in mashery-websocket-eventing folder
3. From Mashery admin console, create an api definition, package and publish for the below petstore endpoint
```
https://petstore.swagger.io/v2/pet/{petId}
```

Note: Created Mashery API can be consumed by using below like curl command:
```bash
curl http://XXXX.api.mashery.com/v1/petStore?petId=12&api_key=XXXXXXXXX
```

4. Update Mashery log streaming service url in the gateway config file [triggers -> settings].

```json
"settings": {
    "url": "<MASHERY_LOGS_STREAMING_URL>"
}
```
Note: logs streaming url can be found in your Mashery admin console. Below is the screenshot for reference:

![Screenshot of Mashery admin console](mashery.png)

5. Create a free tier email service account with [sendgrid.com](https://signup.sendgrid.com), obtain [SENDGRID_API_KEY](https://app.sendgrid.com/settings/api_keys) and update it in the gateway config file.

```json
"Authorization": "Bearer <SENDGRID_API_KEY>"
```

Update gateway config file with your email address.
```json
"email": "<EMAIL_ADDRESS>"
```
## Testing

Start the gateway:

```bash
./mashling-gateway -c websocket-eventing.json
```

Consume created Mashery APIs with different petId values
```bash
curl http://XXXX.api.mashery.com/v1/petStore?petId=12&api_key=XXXXXXXXX
```

You should observe `DETECTED 404` message in the gateway logs when pet is not available and also should receive an email.