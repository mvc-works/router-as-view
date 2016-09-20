
Immutable = require 'immutable'

{fromJS} = Immutable
o = Immutable.Map()

trimSlash = (chunk) ->
  if chunk.substr(0, 1) is '/'
    trimSlash chunk.substr(1)
  else if chunk.substr(-1) is '/'
    trimSlash chunk.substr(0, chunk.length-1)
  else chunk

parseQuery = (data, chunks) ->
  if (chunks.size is 0)
    data
  else
    chunk = chunks.first()
    pieces = chunk.split('=')
    [key, value] = pieces
    key = decodeURIComponent key
    value = decodeURIComponent value
    parseQuery data.set(key, value), chunks.slice(1)

routerBase = Immutable.fromJS
  name: null
  data: {}
  query: {}
  router: null

parsePathSegments = (pathSegments, rules, theQuery) ->
  if pathSegments.size is 0
    null
  else
    pathName = pathSegments.get 0
    if rules.has(pathName)
      argsTemplate = rules.get pathName
      restOfSegments = pathSegments.rest()
      if restOfSegments.size < argsTemplate.size
        routerBase
        .set 'name', '404'
        .set 'query', theQuery
      else
        data = argsTemplate.reduce (acc, argName, idx) ->
          acc.set argName, restOfSegments.get(idx)
        , o
        nextPathSegments = restOfSegments.slice(argsTemplate.size)
        childRouter = parsePathSegments nextPathSegments, rules, theQuery
        if childRouter?
          routerBase
          .set 'name', pathName
          .set 'data', data
          .set 'router', childRouter
        else
          routerBase
          .set 'name', pathName
          .set 'data', data
          .set 'query', theQuery
    else
      routerBase
      .set 'name', '404'
      .set 'query', theQuery

parseAddress = (address) ->
  [chunkPath, chunkQuery] = address.split('?')
  chunkQuery = chunkQuery or ''

  chunkPath = trimSlash(chunkPath)
  thePath = if (chunkPath.length > 0) then chunkPath.split('/') else []
  pathSegments = Immutable.fromJS(thePath.map decodeURIComponent)
  if chunkQuery.length > 0
    theQuery = parseQuery o, Immutable.fromJS(chunkQuery.split('&'))
  else
    theQuery = o

  parsePathSegments pathSegments, rules, theQuery

fill = (pieces, data) ->
  pieces.map (chunk) ->
    if chunk.substr(0, 1) == ':' then data.get(chunk.substr(1)) else chunk

stringify = (info) ->
  stringPath = info.get('path').map(encodeURIComponent).join('/')
  stringQuery = info.get('query')
  .filter (value, key) ->
    value?
  .map (value, key) ->
    key = encodeURIComponent key
    value = encodeURIComponent value
    "#{key}=#{value}"
  .join '&'

  if (stringQuery.length > 0)
    "/#{stringPath}?#{stringQuery}"
  else
    "/#{stringPath}"

addressRunner = (acc, router, rules) ->
  if not router?
    acc
  else
    routerName = router.get 'name'
    argsTemplate = rules.get routerName
    args = argsTemplate.map (argName) ->
      router.get('data').get(argName)
    nextAcc = "#{acc}/#{routerName}/#{args.join '/'}/#{child}"
    addressRunner nextAcc, router.get('router'), rules

  stringify newInfo

makeAddress = (router, rules) ->
  addressRunner '/', router, rules

exports.makeAddress = makeAddress
exports.parseAddress = parseAddress
