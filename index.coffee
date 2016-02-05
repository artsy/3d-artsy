express = require 'express'
sharify = require 'sharify'
imageProxy = require './lib/proxy'
artsyXapp = require 'artsy-xapp'
{ NODE_ENV, ARTSY_ID, ARTSY_SECRET, ARTSY_URL, REDIS_URL, PORT } = require './config'

# App instance
app = module.exports = express()

# Sharify
sharify.data =
  API_URL: ARTSY_URL
  NODE_ENV: NODE_ENV
app.use sharify

# General
app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'

# Asset Middleware
if NODE_ENV is 'development'
  app.use require('browserify-dev-middleware')
    src: __dirname + '/lib'
    transforms: [require('jadeify'), require('caching-coffeeify')]
  app.use require("stylus").middleware
    src: __dirname + '/stylesheets'
    dest: __dirname + '/public'

# Routes
app.get '/', (req, res) ->
  res.locals.sd.XAPP_TOKEN = artsyXapp.token
  res.render 'index'
app.use "/proxy", imageProxy

# Static Middleware
app.use express.static __dirname + '/public'

# Listen
artsyXapp.init
  url: ARTSY_URL
  id: ARTSY_ID
  secret: ARTSY_SECRET
, ->
  app.listen PORT, ->
    console.log 'listening on 4000'