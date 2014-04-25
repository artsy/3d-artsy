THREE = require 'three'

geometry = new THREE.PlaneGeometry 2000, 2000, 10, 10
geometry.applyMatrix new THREE.Matrix4().makeRotationX( - Math.PI / 2 )
material = new THREE.MeshBasicMaterial color: 0xf5f5f5
floor = new THREE.Mesh geometry, material

module.exports = floor