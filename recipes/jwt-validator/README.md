# JWT Validator
This recipe adds a JWT Validation to the Http service.

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/jwt-validator
```
Place the Downloaded Mashling-Gateway binary in jwt-validator folder.

## Testing

Generate a JWT token using the below information:
(You may use http://jwtbuilder.jamiekurtz.com/)

```
{
     "signingMethod": "HMAC",
     "id": "XX",
     "audience": "www.mashling.io",
     "issuer": "Mashling"
}
{
     "key": "qwertyuiopasdfghjklzxcvbnm789101"
}
```
Note: The id in the above payload is the pet Id.

Start the gateway:
```
./mashling-gateway -c jwt-validator.json
```

### JWT Validation

Place the generated JWT Token in the authorization header.

Use below curl command to fetch the pet details.

```
curl --request GET http://localhost:9096/pets -H "Authorization: Bearer <ACCESS_TOKEN>"

```
Sample JWT Valid Response:
```json
{
 "JWT": "JWT token is valid",
 "pet": {
  "category": {
   "id": 15,
   "name": "string"
  },
  "id": 15,
  "name": "DavidsDog- Growl",
  "photoUrls": [
   "string"
  ],
  "status": "Dead",
  "tags": [
   {
    "id": 15,
    "name": "string"
   }
  ]
 }
}
```
The below response is seen when we pass the Invalid Access Token.

```json
{
 "error": {
  "valid": false,
  "token": {
   "claims": null,
   "signature": "",
   "signingMethod": "",
   "header": null
  },
  "validationMessage": "ERROR_MESSAGE",
  "error": false,
  "errorMessage": ""
 }
}
```