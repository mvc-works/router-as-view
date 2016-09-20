
router = require './router'

module.exports = (store, actionType, actionData) ->
  switch actionType
    when 'router/go'
      router.go store, actionData
    when 'router/route1'
      router.route1 store, actionData
    when 'router/route2'
      router.route2 store, actionData
    when 'router/route3'
      router.route3 store, actionData
    else
      console.warn ":Unknown action type: #{actionType}"
      store
