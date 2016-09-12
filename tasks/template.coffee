

stir = require('stir-template')
settings = require('./settings')
resource = require('./resource')

{html, head, title, meta, link, script, body, div, style} = stir

logoUrl = 'http://mvc-works.org/png/mvc.png'

module.exports = (env) ->
  config = settings.get(env)
  assets = resource.get(config)
  stir.render stir.doctype(),
    html {},
      head {},
        title {}, 'Router As View'
        meta charset: 'utf-8'
        link rel: 'icon', href: logoUrl
        if assets.style?
          link rel: 'stylesheet', href: assets.style
        script src: assets.vendor, defer: true
        script src: assets.main, defer: true
        style {}, 'body * {box-sizing: border-box;}'
    body style: 'margin: 0;',
      div id: 'app'
