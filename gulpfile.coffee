
fs = require('fs')
gulp = require('gulp')
gutil = require('gulp-util')
sequence = require('run-sequence')

settings = require('./tasks/settings')

env = 'dev'

gulp.task 'rsync', (cb) ->
  wrapper = require('rsyncwrapper')
  wrapper.rsync
    ssh: true
    src: [ 'build/*' ]
    recursive: true
    args: [ '--verbose' ]
    dest: 'tiye:~/repo/workflow/'
    deleteAll: true
  , (error, stdout, stderr, cmd) ->
    if error != null
      throw error
    console.error stderr
    console.log cmd
    cb()

gulp.task 'script', ->
  coffee = require('gulp-coffee')
  gulp
  .src 'src/*.coffee'
  .pipe coffee bare: yes
  .pipe gulp.dest('lib/')

gulp.task 'html', (cb) ->
  html = require('./tasks/template')
  fs = require('fs')
  fs.writeFile 'build/index.html', html(env), cb

gulp.task 'del', (cb) ->
  del = require('del')
  del [ 'build/**/*' ], cb

gulp.task 'webpack-dev', (cb) ->
  webpack = require('webpack')
  webpackDev = require('./tasks/webpack-dev')
  WebpackDevServer = require('webpack-dev-server')
  config = settings.get('dev')
  webpackServer =
    publicPath: '/'
    hot: true
    stats: colors: true
  info =
    __dirname: __dirname
    env: env
  compiler = webpack(webpackDev(info))
  server = new WebpackDevServer(compiler, webpackServer)
  server.listen config.port, '0.0.0.0', (err) ->
    if err?
      throw new (gutil.PluginError)('webpack-dev-server', err)

    gutil.log '[webpack-dev-server] is running...'
    cb()

gulp.task 'webpack-build', (cb) ->
  webpack = require('webpack')
  webpackBuild = require('./tasks/webpack-build')
  config = settings.get(env)
  info =
    __dirname: __dirname
    isMinified: config.isMinified
    useCDN: config.useCDN
    cdn: config.cdn
    env: config.env
  webpack webpackBuild(info), (err, stats) ->
    if err
      throw new (gutil.PluginError)('webpack', err)
    gutil.log '[webpack]', stats.toString()
    jsonData = stats.toJson()
    fileContent = JSON.stringify(jsonData.assetsByChunkName)
    fs.writeFileSync 'build/assets.json', fileContent
    cb()

gulp.task 'dev', (cb) ->
  sequence 'html', 'webpack-dev', cb

gulp.task 'build', (cb) ->
  env = 'build'
  sequence 'del', 'webpack-build', 'html', cb
