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
     "username": "xxxxxxx",
     "audience": "www.mashling.io",
     "issuer": "Mashling"
}
```

Start the gateway:
```
./mashling-gateway -c jwt-validator.json
```

### JWT Validation

Place the generated JWT Token in the authorization header.

Use below curl command.

```
curl --request GET http://localhost:9096/pets/9 -H "Authorization: Bearer <ACCESS_TOKEN>"

```
