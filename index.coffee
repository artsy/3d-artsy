express = require 'express'
sharify = require 'sharify'
artsyXappMiddlware = require 'artsy-xapp-middleware'
imageProxy = require './lib/proxy'
{ NODE_ENV, ARTSY_ID, ARTSY_SECRET, ARTSY_URL, REDIS_URL } = require './config'

# App instance
app = module.exports = express()

# Sharify
sharify.data =
  API_URL: ARTSY_URL
  NODE_ENV: NODE_ENV
app.use sharify

# XAPP middlware
app.use artsyXappMiddlware
  artsyUrl: ARTSY_URL
  clientId: ARTSY_ID
  clientSecret: ARTSY_SECRET

# General
app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'
app.use express.logger('dev')
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router

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
  res.locals.sd.XAPP_TOKEN = res.locals.artsyXappToken
  res.render 'index'
app.use "/proxy", imageProxy

# Static Middleware
app.use express.static __dirname + '/public'

# Listen
app.listen 5000, ->
  console.log 'listening on 5000'