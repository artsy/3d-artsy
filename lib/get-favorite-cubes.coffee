# 
# Fetches a user's favorites and turns them into three.js cubes
# 
# @param {String} id 
# @param {Object} options
#

_ = require 'underscore'
Backbone = require 'backbone'
Artwork = require '../models/artwork.coffee'
THREE = require 'three'
{ API_URL } = require('sharify').data

fetchFavorites = (id, options) ->
  $.ajax
    url: "#{API_URL}/api/v1/profile/#{id}"
    error: options.error
    success: (res) ->
      artworks = new Backbone.Collection
      artworks.model = Artwork
      artworks.url = "#{API_URL}/api/v1/collection/saved-artwork/artworks"
      artworks.fetch _.extend
        data:
          sort: '-position'
          user_id: res.owner.id
          private: true
          size: 50
      , options

artworkCube = (artwork) ->
  texture = THREE.ImageUtils.loadTexture(artwork.defaultImageUrl(), THREE.UVMapping)
  material = new THREE.MeshBasicMaterial color: 0xffffff, map: texture
  geometry = new THREE.CubeGeometry artwork.toCube()...
  mesh = new THREE.Mesh geometry, material
  mesh.position.y = artwork.toCube()[1] / 2 + 2
  wallHeight = 70
  wallPadding = 10
  geometry = new THREE.CubeGeometry(
    artwork.toCube()[0] + wallPadding,
    wallHeight = (artwork.toCube()[1] + wallPadding),
    1.5
  )
  material = new THREE.MeshBasicMaterial color: 0xffffff
  wall = new THREE.Mesh geometry, material
  wall.position.z = -1
  wall.position.y = 0
  mesh.add wall
  mesh.artwork = artwork
  mesh

module.exports = (id, options) ->
  fetchFavorites id,
    error: options.error
    success: (favorites) ->
      options.success _.map favorites.filter((artwork) -> artwork.get('dimensions')?.in), artworkCube