
React = require 'react'
ReactDOM = require 'react-dom'
recorder = require 'actions-in-recorder'

Immutable = require 'immutable'
installDevTools = require 'immutable-devtools'


require '../styles/main.css'

schema = require './schema'
updater = require './updater'
pathUtil = require './path'
routes = require './routes'

Container = React.createFactory require './app/container'

installDevTools(Immutable)

# oldAddress = "#{location.pathname}#{location.search}"
oldAddress = location.hash.substr(1)
router = pathUtil.parseAddress(oldAddress, routes)
defaultInfo =
  initial: schema.store.set 'router', router
  updater: updater

console.log router
recorder.setup defaultInfo

render = (core) ->
  target = document.querySelector('#app')
  ReactDOM.render Container(core: core), target

recorder.request render
recorder.subscribe render
