# Roblox Bulk Publish

A simple tool to publish several Roblox places at once.

This requires having [Lune](https://lune-org.github.io/docs) installed.
The recommended installation is using [Aftman](https://github.com/LPGhatguy/aftman).

## Usage
To use, modify the `place_ids.json` file. This file is a dictionary that maps identifiers to lists of ids. For example:
```json
{
	"default": [1, 2, 3, 4, 5],
	"development": [6, 7, 8]
}
```
When the `default` identifier is chosen, it will publish the ids 1, 2, 3, 4, and 5.
When the `development` identifier is chosen, it will instead publish the ids 6, 7, and 8.

To run the tool, set your current working directory to the folder and run the `bulk_publish.luau` file with Lune.
With no arguments, it will use `default` as the identifier:
```
lune bulk_publish
```

If arguments are given, it will use the first argument as the identifier (unless the argument begins with `-`):
```
lune bulk_publish development
```

## Authentication
This uses Lune to fetch your Roblox Studio credentials, so manually adding them should not be needed.
If you are having issues, try opening studio and make sure that you are signed into an account with the necessary permissions.