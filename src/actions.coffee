
recorder = require 'actions-in-recorder'

exports.go = (info) ->
  console.log 'go', info
  recorder.dispatch 'router/go', info
