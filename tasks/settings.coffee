
exports.get = (env) ->
  switch env
    when 'dev'
      env: 'dev'
      host: 'http://localhost'
      port: 8080
    when 'build'
      env: 'build'
      host: 'http://localhost'
      port: 8080
