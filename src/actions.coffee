
recorder = require 'actions-in-recorder'
routes = require './routes'
pathUtil = require './path'

exports.go = (info) ->
  console.log 'go', info
  recorder.dispatch 'router/go', info

exports.nav = (piece) ->
  router = pathUtil.parseAddress piece, routes
  recorder.dispatch 'router/go', router
