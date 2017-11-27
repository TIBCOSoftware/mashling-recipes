# Tunable HTTP Router
This recipe routes traffic between different end-points based on the context supplied as environment flag. End-point can be configured in event_link's dispatch section.

## Installation
* Mashling [CLI](https://github.com/TIBCOSoftware/mashling)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/tunable-rest-gateway
mashling create -f tunable-rest-gateway.json tunable-rest-gateway
```

## Testing

Navigate to tunable-rest-gateway/bin folder and try below scenarios.

### Query PetStore end-point

```
export API_CONTEXT=PETS
./tunable-rest-gateway
```
In a saparate terminal run below curl command to try GET pet# 17 details.

```
curl --request GET http://localhost:9096/id/17
```

### Query UserStore end-point

```
export API_CONTEXT=USERS
./tunable-rest-gateway
```
In a saparate terminal run below curl command to try GET user# 17 details.

```
curl --request GET http://localhost:9096/id/17
```