
Router as a View in React
----

> Location bar is a view of store

This project is based on `react`, `immutable` and `actions-recorder`.

Demo http://repo.react-china.org/router-as-view

### Initial idea

Router is part of MVC and we can certainly divide it into M, C and V for better managements.
It's like `react-redux-router` but designed based on `actions-recorder`.

Ideas behind it: [Router is a View](https://hashnode.com/post/router-is-a-view-cil5959bn00kqa653p0y42gpu)

### Usage

```bash
npm i --save router-as-view
```

Router DSL is defined in an immutable Map:

```coffee
Addressbar = require 'router-as-view'
pathUtil = require 'router-as-view/lib/path'

routes = Immutable.fromJS
  home: [] # means / or /home
  demo: [] # means /demo
  team: ['teamId'] # means /team/:teamId
  room: ['roomId'] # means /room/:roomId
  '中文': ['中文'] # means /中文/:中文

# oldAddress = "#{location.pathname}#{location.search}" # for history API
oldAddress = location.hash.substr(1) # to remove sharp mark
router = pathUtil.parseAddress oldAddress, routes
store = store.set 'router', router
```

Notice that 2 of the paths are different:

* `home` is generated when `/` or `/home` is found
* `404` is generated when no router is found


`M` part, add initial router object in store. It looks like:

```coffee
name: 'team'
data:
  teamId: '12'
query:
  isPrivate: 'true'
router: # nested router is parsed from address directly
  name: 'room'
  data:
    roomId: '34'
  query: {}
  router: null
```

Parameters and querystrings are supported. Get this from store and render the page.

"V" part, mount `Addressbar` component to manipulate History API:

```coffee
Addressbar
  router: store.get('router')
  routes: routes
  onPopstate: (info, event) ->
    # figure out the new router object and dispatch a `router/go` action
  inHash: true # fallback to hash from history API
  skipRendering: false # true to allow model/view inconsistency during loading
```

"C" part, connect action to store:

```coffee
switch actionType
  when 'router/go' # <--- bind this action
    router.go store, actionData
  else
    console.warn ":Unknown action type: #{actionType}"
    store
```

Read [`src/`](https://github.com/jianliaoim/router-as-view/tree/master/src) for details.

### Notice

* keep in mind that `router-as-view` is totally based on `immutable-js`.
* if you need to route asynchronously, try set `skipRendering` to `true` during loading
* `undefined` value is eliminated on purpose, fire an issue if you think differenly.

### License

MIT
