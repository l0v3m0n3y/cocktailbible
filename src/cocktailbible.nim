import asyncdispatch, httpclient, json, strutils, uri

const api = "https://cocktail-bible.com/api"
var headers = newHttpHeaders({
    "Connection": "keep-alive",
    "user-agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.3",
    "Host": "cocktail-bible.com",
    "Content-Type": "application/json",
    "accept": "application/json"
})

proc get_cocktails_library*(
  limit: int = 12,
  skip: int = 0,
  sort: string = "createdOn",
  ingredient: string = "",
  nonAlcoholic: bool = false,
  creamy: bool = false,
  difficulty: string = "",
  sour: bool = false,
  excludeID: string = "",
  version: string = ""
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers 
  try:
    var url = api & "/cocktails/library?"
    url.add("limit=" & $limit & "&")
    url.add("skip=" & $skip & "&")
    url.add("sort=" & sort & "&")
    
    if ingredient != "":
      url.add("ingredient=" & encodeUrl(ingredient) & "&")
    if nonAlcoholic:
      url.add("attributes_non_alcoholic=true&")
    if creamy:
      url.add("attributes_creamy=true&")
    if difficulty != "":
      url.add("difficulty=" & encodeUrl(difficulty) & "&")
    if sour:
      url.add("attributes_sour=true&")
    if excludeID != "":
      url.add("excludeID=" & encodeUrl(excludeID) & "&")
    if version != "":
      url.add("version=" & encodeUrl(version) & "&")
   
    if url[^1] == '&':
      url.setLen(url.len - 1)
    
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc get_posts*(
  limit: int = 15,
  skip: int = 0,
  sort: string = "createdOn"
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers 
  try:
    let url = api & "/posts/find-all?limit=" & $limit & "&skip=" & $skip & "&sort=" & sort
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc get_cocktail_images*(cocktailId: string): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers 
  try:
    let url = api & "/cocktail-images/cocktail/" & encodeUrl(cocktailId)
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()
