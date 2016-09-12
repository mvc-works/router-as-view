
path = require('path')
webpack = require('webpack')
webpackDev = require('./webpack-dev')
ExtractTextPlugin = require('extract-text-webpack-plugin')

module.exports = (info) ->
  webpackConfig = webpackDev(info)
  # returns
  entry:
    main: [ './src/main' ]
    vendor: ['react', 'immutable']
  output:
    path: path.join(info.__dirname, 'build/')
    filename: '[name].[chunkhash:8].js'
  resolve: webpackConfig.resolve
  module:
    loaders: [
      {test: /\.coffee$/, loader: 'coffee', ignore: /node_modules/}
      {test: /.(png|jpg)$/, loader: 'url-loader', query: limit: 100}
      {test: /\.css$/, loader: ExtractTextPlugin.extract('style-loader', 'css!autoprefixer')}
    ]
  plugins: [
    new (webpack.optimize.CommonsChunkPlugin)('vendor', 'vendor.[chunkhash:8].js')
    new ExtractTextPlugin('style.[chunkhash:8].css')
    new (webpack.optimize.UglifyJsPlugin)(sourceMap: false)
  ]
