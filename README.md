# cocktailbible
api for cocktail-bible.com service forn getting cocktail recepe
# Example
```nim
import asyncdispatch, cocktailbible, json, strutils
let cocktails = waitFor get_cocktails_library()
let cocktail_list = cocktails["results"]
for cocktail in cocktail_list:
  echo cocktail["id"].getStr()
  echo cocktail["name"].getStr()
  echo cocktail["imgURL"].getStr()
  echo cocktail["glass"].getStr()
  echo cocktail["searchEN"].getStr()
  echo ".".repeat(40)
```

# Launch (your script)
```
nim c -d:ssl -r  your_app.nim
```
