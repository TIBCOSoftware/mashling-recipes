# Gateway with GraphQL
This recipe is a gateway with GraphQL requests.

## Installation
* Download the Mashling-Gateway Binary for respective OS from [Mashling](https://github.com/TIBCOSoftware/mashling/tree/master#installation-and-usage)

## Setup
```
git clone https://github.com/TIBCOSoftware/mashling-recipes
cd mashling-recipes/recipes/graphql-gateway
```
Place the Downloaded Mashling-Gateway binary in graphql-gateway folder.

## Testing
Start the gateway:
```
export BASIC_AUTH_FILE=<PATH MASHLING RECIPES IS IN>/mashling-recipes/recipes/graphql-gateway/passwd.txt
./mashling-gateway -c graphql-gateway.json
```
and test below scenario.

### GraphQL request
Run the following command:
```
curl 'http://localhost:9096/graphql' -u foo:bar -H 'Content-Type: application/json' --data-binary '{"query":"{\n  products: allProducts(count: 3) {\n    id\n    name\n    price\n  }\n}","operationName":null}'
```

You should see a response similar to:
```json
{
 "products": [
  {
   "id": "cjkcxuf4800fi2c10zh78h526",
   "name": "Small Concrete Sausages",
   "price": "573.00"
  },
  {
   "id": "cjkcxuf4800fj2c10ak6j5xz7",
   "name": "Incredible Metal Fish",
   "price": "221.00"
  },
  {
   "id": "cjkcxuf4800fk2c1023rg7urb",
   "name": "Handmade Soft Soap",
   "price": "541.00"
  }
 ],
 "total": 1335,
 "user": {
  "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/adrienths/128.jpg",
  "email": "Trevor_Wintheiser87@yahoo.com",
  "firstName": "Jeremy",
  "id": "wk0z1j1tzj7xc0116is3ckdrx",
  "lastName": "Monahan"
 }
}
```
