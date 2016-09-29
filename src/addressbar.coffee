
React = require 'react'
Immutable = require 'immutable'
pathUtil = require './path'

div = React.createFactory 'div'

module.exports = React.createClass
  displayName: 'addressbar'

  propTypes:
    router: React.PropTypes.instanceOf(Immutable.Map).isRequired
    routes: React.PropTypes.instanceOf(Immutable.Map).isRequired
    onPopstate: React.PropTypes.func.isRequired
    inHash: React.PropTypes.bool
    skipRendering: React.PropTypes.bool

  getDefaultProps: ->
    inHash: true
    skipRendering: false

  inHash: ->
    @props.inHash or (not window.history?)

  componentDidMount: ->
    if @inHash()
      window.addEventListener 'hashchange', @onHashchange
    else
      window.addEventListener 'popstate', @onPopstate

  componentWillUnmount: ->
    if @inHash()
      window.removeEventListener 'hashchange', @onHashchange
    else
      window.removeEventListener 'popstate', @onPopstate

  onPopstate: (event) ->
    address = location.pathname + (location.search or '')
    info = pathUtil.parseAddress address, @props.routes
    @props.onPopstate info, event

  onHashchange: ->
    if location.hash is @_cacheRenderedHash
      # changing hash in JavaScript will trigger event, by pass
      return
    address = location.hash.substr(1)
    info = pathUtil.parseAddress address, @props.routes
    @props.onPopstate info

  renderInHistory: (address) ->
    routes = @props.routes
    address = pathUtil.makeAddress @props.router, routes
    if location.search?
      oldAddress = "#{location.pathname}#{location.search}"
    else
      oldAddress = location.pathname

    if oldAddress isnt address and not @props.skipRendering
      history.pushState null, null, address

  renderInHash: (address) ->
    routes = @props.routes
    address = pathUtil.makeAddress @props.router, routes

    oldAddress = location.hash.substr(1)

    if oldAddress isnt address and not @props.skipRendering
      location.hash = "##{address}"
      @_cacheRenderedHash = location.hash

  render: ->
    if (typeof window) isnt 'undefined'
      if @inHash()
        @renderInHash()
      else
        @renderInHistory()

    div className: 'addressbar'
