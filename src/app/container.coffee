React = require('react')
pureRenderMixin = require('react-addons-pure-render-mixin')
Immutable = require('immutable')

actions = require('../actions')
routes = require('../routes')
updater = require '../updater'

Devtools = React.createFactory require('actions-in-recorder/lib/devtools')
Addressbar = React.createFactory(require('../addressbar'))

a = React.createFactory('a')
div = React.createFactory('div')
pre = React.createFactory('pre')
span = React.createFactory('span')

module.exports = React.createClass
  displayName: 'app-container'

  mixins: [ pureRenderMixin ]

  propTypes:
    core: React.PropTypes.instanceOf(Immutable.Map)

  getInitialState: ->
    path: Immutable.List()

  goDemo: ->
    actions.go
      name: 'demo'
      data: null
      query: {}
  goHome: ->
    actions.go
      name: 'home'
      data: null
      query: {}
  goTeam: ->
    actions.go
      name: 'team'
      data: teamId: '12'
      query: {}
  goRoom: ->
    actions.go
      name: 'team'
      data:
        teamId: '23'
      query: {}
      router:
        name: 'room'
        data:
          roomId: '34'
        query: {}
  goQuery: ->
    actions.nav 'team/23/room/34?isPrivate=true'
    # actions.go
    #   name: 'team'
    #   data:
    #     teamId: '23'
    #   query: {}
    #   router:
    #     name: 'room'
    #     data:
    #       roomId: '34'
    #     query:
    #       isPrivate: 'true'
  goChinese: ->
    actions.go
      name: '中文'
      data:
        '中文': '中文'
      query:
        '中文': '中文'

  onPopstate: (info, event) ->
    actions.go info.toJS()

  renderAddress: ->
    Addressbar
      router: @props.core.get('store').get('router')
      routes: routes
      onPopstate: @onPopstate
      inHash: true

  renderDevtools: ->
    core = @props.core
    Devtools
      core: core
      width: 800
      height: window.innerHeight
      path: @state.path
      onPathChange: (newState) =>
        @setState path: newState

  renderBanner: ->
    div className: 'bannr',
      div className: 'heading level-2', 'Router View for React'
      div className: '',
        span(null, 'Location bar is a view! So we time travel! ')
        a href: 'http://github.com/react-china/router-as-view', 'Read more on GitHub'

  renderUI: ->
    div className: 'app-ui',
      @renderBanner()
      @renderAddress()
      div(className: 'page-divider')
      div className: 'line',
        div className: 'button is-attract', onClick: @goHome, 'goHome'
        div className: 'button is-attract', onClick: @goDemo, 'goDemo'
        div className: 'button is-attract', onClick: @goTeam, 'goTeam'
        div className: 'button is-attract', onClick: @goRoom, 'goRoom'
        div className: 'button is-attract', onClick: @goQuery, 'goQuery'
        div className: 'button is-attract', onClick: @goChinese, 'goChinese'
      div(className: 'page-divider')
      div { className: 'line' },
        span({ className: 'is-bold' }, 'Store is:')
      pre { className: 'page-content' },
        JSON.stringify(@props.core.get('store'), null, 2)

  render: ->
    div className: 'app-page',
      @renderUI()
      div className: 'devtools-layer',
        @renderDevtools()
