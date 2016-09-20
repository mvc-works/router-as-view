
exports.go = (store, info) ->
  store.set 'router', info

exports.route1 = (store, info) ->
  store.set 'router', info

exports.route2 = (store, info) ->
  store.setIn ['router', 'router'], info

exports.route3 = (store, info) ->
  store.setIn ['router', 'router', 'router'], info
