window.THREE = require 'three'
require 'three/examples/js/controls/PointerLockControls.js'
require('backbone').$ = $
getFavoriteCubes = require './get-favorite-cubes.coffee'
room = require './room.coffee'
{ XAPP_TOKEN, ARTWORK_ID  } = require('sharify').data

time = null

# Add XAPP to headers
$.ajaxSettings.headers = 'X-XAPP-TOKEN'  : XAPP_TOKEN

# Setup scene & renderer
scene = new THREE.Scene()
renderer = new THREE.WebGLRenderer({ antialias: true })
renderer.setClearColor( 0xffffff )
renderer.setSize $(window).width(), $(window).height()

# Setup Camera & Controls
camera = new THREE.PerspectiveCamera 75, $(window).width() / $(window).height(), 0.1, 1000
camera.position.z = 5
controls = new THREE.PointerLockControls camera
scene.add controls.getObject()

# Lights
light = new THREE.DirectionalLight( 0xffffff, 1.5 );
light.position.set( 1, 1, 1 )
scene.add( light )

# Append Canvas
init = (cubes) ->
  placeWork(cubes)
  render()
  scene.add room
  controls.enabled = true
  $('#main-spinner').remove()

placeWork = (cubes) ->
  window.cubes = cubes
  for cube, i in cubes
    scene.add(cube)
    cube.position.x = (Math.random() * 500) - 250
    cube.position.z = (Math.random() * 500) - 250
    cube.rotation.y = if Math.random() > 0.5 then 1.65 else 0

render = ->
  requestAnimationFrame render
  # controls.update Date.now() - time
  renderer.render scene, camera
  time = Date.now()

err = (err) ->
  console.warn err

$ ->
  $('#canvas-container').html renderer.domElement
  getFavoriteCubes location.hash.replace('#','') or 'craig',
    error: err
    success: (cubes) ->
      init(cubes)