module.exports =
  NODE_ENV: 'development'
  ARTSY_ID: ''
  ARTSY_SECRET: ''
  ARTSY_URL: 'https://api.artsy.net'
  REDIS_URL: 'http://localhost:6379'
  PORT: 4000

module.exports[key] = (process.env[key] or val) for key, val of module.exports