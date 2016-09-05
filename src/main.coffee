
React = require 'react'
ReactDOM = require 'react-dom'
recorder = require 'actions-in-recorder'

require '../styles/main.css'

schema = require './schema'
updater = require './updater'
pathUtil = require './path'
routes = require './routes'

Page = React.createFactory require './app/page'

oldAddress = "#{location.pathname}#{location.search}"
# oldAddress = location.hash.substr(1)
router = pathUtil.getCurrentInfo(routes, oldAddress)
defaultInfo =
  initial: schema.store.set 'router', router
  updater: updater

recorder.setup defaultInfo

render = (core) ->
  target = document.querySelector('#app')
  ReactDOM.render Page(core: core), target

recorder.request render
recorder.subscribe render
