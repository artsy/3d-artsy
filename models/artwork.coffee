Backbone = require 'backbone'
{ API_URL } = require('sharify').data

IN_TO_THREE_RATIO = 0.5

module.exports = class Artwork extends Backbone.Model

  urlRoot: "#{API_URL}/api/v1/artwork/"

  defaultImageUrl: ->
    '/proxy?url=' + @get('images')[0].image_url.replace(':version', 'large')

  toCube: ->
    width = Math.round parseInt @get('dimensions')['in'].split('×')[1]
    height = width / @get('images')[0].aspect_ratio or
             Math.round parseInt @get('dimensions')['in'].split('×')[0]
    [width * IN_TO_THREE_RATIO, height * IN_TO_THREE_RATIO, 0.2]