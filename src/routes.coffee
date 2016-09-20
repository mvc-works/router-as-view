
pathUtil = require './path'

Immutable = require 'immutable'

# assume router in format of `/a/:a-arg1/:arg-n/b/b-arg1`
module.exports = Immutable.fromJS
  home: []
  demo: []
  skip: []
  team: ['teamId']
  room: ['roomId']
  '中文': []
