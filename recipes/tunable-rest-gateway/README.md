# Tunable HTTP Router
This recipe routes traffic between different end-points based on the context supplied as environment flag. End-point can be configured in event_link's dispatch section.

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage) 

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/tunable-rest-gateway 
```
Place the Downloaded Mashling-Gateway binary in tunable-rest-gateway folder.

## Testing

Navigate to tunable-rest-gateway folder and try below scenarios.

### Query PetStore end-point

```
export API_CONTEXT=PETS
./mashling-gateway -c tunable-rest-gateway.json
```
In a separate terminal run below curl command to try GET pet# 17 details.

```
curl --request GET http://localhost:9096/id/17
```

### Query UserStore end-point

```
export API_CONTEXT=USERS
./mashling-gateway -c tunable-rest-gateway.json
```
In a separate terminal run below curl command to try GET user# 17 details.

```
curl --request GET http://localhost:9096/id/17
```