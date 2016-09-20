
assert = require 'assert'
Immutable = require 'immutable'

pathUtil = require './src/path'

o = Immutable.Map()
fromJS = Immutable.fromJS

testTrimSlash = ->
  console.log "* test on trim slash"
  assert.equal pathUtil.trimSlash('/a/b/c'), 'a/b/c'
  assert.equal pathUtil.trimSlash('/a/b/'), 'a/b'

testQueryParse = ->
  console.log '* test on query parser'
  result = pathUtil.parseQuery(o, fromJS('a=1&b=2'.split('&')))
  expected = {a: '1', b: '2'}
  assert.deepEqual result.toJS(), expected

testChineseQueryParse = ->
  console.log '* test on Chinese query parser'
  text = encodeURIComponent '中文'
  result = pathUtil.parseQuery(o, fromJS("#{text}=#{text}".split('&')))
  expected = {'中文': '中文'}
  assert.deepEqual result.toJS(), expected

testLongQueryParse = ->
  console.log '* test on long query parser'
  longPath = 'ct=503316480&z=0&ipn=d&word=%E9%80%94%E5%AE%89&step_word=&pn=0&spn=0&di=1712569540&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=2464434574%2C440997798&os=1619671487%2C69261469&simid=3496201219%2C355884747&adpicid=0&ln=1000&fr=&fmq=1457507365044_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fphotocdn.sohu.com%2F20111102%2FImg324265977.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3F65ss_z%26e3Bf5i7_z%26e3Bv54AzdH3Fda8888adAzdH3Fgnd9dmcl0m_z%26e3Bfip4s&gsm=0'
  result = pathUtil.parseQuery(o, fromJS(longPath.split('&')))
  expected = {"gsm":"0","lm":"-1","st":"-1","ln":"1000","oriquery":"","adpicid":"0","cg":"","os":"1619671487,69261469","istype":"2","di":"1712569540","in":"","fromurl":"ippr_z2C$qAzdH3FAzdH3F65ss_z&e3Bf5i7_z&e3Bv54AzdH3Fda8888adAzdH3Fgnd9dmcl0m_z&e3Bfip4s","width":"","ipn":"d","fm":"","height":"","cl":"2","fmq":"1457507365044_R","ist":"","is":"","word":"途安","sme":"","fr":"","cs":"2464434574,440997798","ct":"503316480","spn":"0","simid":"3496201219,355884747","se":"","s":"undefined","jit":"","tab":"0","oe":"utf-8","objurl":"http://photocdn.sohu.com/20111102/Img324265977.jpg","pi":"","z":"0","ic":"0","tn":"baiduimagedetail","ie":"utf-8","rn":"1","bdtype":"0","step_word":"","face":"undefined","pn":"0"}
  assert.deepEqual result.toJS(), expected

testMakeAddress = ->
  console.log '* test make address'
  routes = fromJS a: [], b: ['c']
  route = fromJS
    name: 'b'
    data:
      c: '1'
    query:
      a: 'x'
  result = pathUtil.makeAddress route, routes
  expected = '/b/1?a=x'
  assert.equal result, expected

testMakeChineseAddress = ->
  console.log '* test make chinese address'
  routes = fromJS a: [], '中文': ['name']
  route = fromJS
    name: '中文'
    data:
      name: '中文'
    query:
      '中文': '中文'
  result = pathUtil.makeAddress route, routes
  expected = '/中文/中文?%E4%B8%AD%E6%96%87=%E4%B8%AD%E6%96%87'
  assert.equal result, expected

# Run

exports.run = ->

  testTrimSlash()
  testQueryParse()
  testChineseQueryParse()
  testLongQueryParse()
  testMakeAddress()
  testMakeChineseAddress()

exports.run()
