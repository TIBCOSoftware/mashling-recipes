# mashling-recipes
> Recipes for Mashling

A recipe is a pre-configured mashling json file which can be customized or used as is for a specific gateway use case. The pre-compiled recipe binaries along with the json files are available in mashling.io website.

## How to contribute a recipe to mashling-recipes

### Adding a recipe
A recipe should be contained in its own folder under mashling-recipes/recipes folder. The recipe folder should have the mashling json file, README.md and an optional icon image file. In the absence of the icon image file, the default mashling icon is used in mashling.io for the recipe. When the icon image file is present, the mashling json file should have an icon image file field as follows:

```json
{
	"mashling_schema": "0.2",
	"gateway": {
		"name": "allRecipe",
		"version": "1.0.0",
		"display_name":"KafkaTrigger to KafkaPublisher",
		"display_image":"displayImage.svg",
		"..."
  }
}
```

If "display_name" field is present in the json, its value is used as the recipe name in mashling.io. Otherwise, the value of "name" field is used.

### Publishing a recipe

recipe_registry.json contains the list of recipe providers and the recipes to publish. The recipe folder name should be added to the "publish" field for the recipe to be made available in mashling.io. For example, KafkaTrigger-To-KafkaPublisher recipe gateway binaries are built and made downloadable from mashling.io given the following recipe_registry.json:

```json
{
    "recipe_repos": [
	{
            "provider": "TIBCOSoftware Engineering",
	    "description": "Mashling gateway recipes from TIBCOSoftware Engineering",
            "publish": "KafkaTrigger-To-KafkaPublisher, KafkaTrigger-To-RestInvoker"
        },
        {
            "provider": "TIBCOSoftware Services",
            "description": "Mashling gateway recipes from TIBCO Services",
            "publish": ""
        }
    ]
}
```

## License
mashling-recipes is licensed under a BSD-type license. See license text [here](https://github.com/TIBCOSoftware/mashling-recipes/blob/master/TIBCO%20LICENSE.txt).

## Support
You can post your questions via [GitHub issues](https://github.com/TIBCOSoftware/mashling-recipes/issues).
