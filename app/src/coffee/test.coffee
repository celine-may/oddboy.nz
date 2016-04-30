if !Detector.webgl
  Detector.addGetWebGLMessage()
camera = undefined
scene = undefined
renderer = undefined
mat = undefined
geom = undefined
composer = undefined
effect = undefined
copyPass = undefined
msaaRenderPass = undefined
param = MSAASampleLevel: 2
mouseX = 0
mouseY = 0
windowHalfX = window.innerWidth / 2
windowHalfY = window.innerHeight / 2

init = ->
  # Scene
  scene = new (THREE.Scene)
  scene.fog = new (THREE.FogExp2)(0x020711, 0.03)

  # Renderer
  renderer = new (THREE.WebGLRenderer)(antialias: false)
  renderer.setClearColor scene.fog.color
  renderer.setPixelRatio window.devicePixelRatio
  renderer.setSize window.innerWidth, window.innerHeight
  container = document.getElementById('container')
  container.appendChild renderer.domElement

  # Camera
  camera = new (THREE.PerspectiveCamera)(60, window.innerWidth / window.innerHeight, 0.1, 1000)
  camera.position.x = 2
  camera.position.y = 4.5
  camera.position.z = 0

  # Grid
  grid = new (THREE.GridHelper)(500, 4)
  color = new (THREE.Color)('rgb(250,71,100)')
  grid.setColors color, 0xfa4764
  scene.add grid
  TweenMax.to grid.position, 20, z: 300

  # Load objects (oddboy)
  material = new (THREE.MeshPhongMaterial)(color: 0x26e2e3)
  materialTwo = new (THREE.MeshPhongMaterial)(color: 0xf8465e)
  loader = new (THREE.ObjectLoader)
  loader.load "#{App.path}assets/objects/oddboy.json", (oddboyTextOne) ->
    oddboyTextOne.traverse (child) ->
      if child instanceof THREE.Mesh
        child.material = material
      return
    oddboyTextOne.position.x = 2
    oddboyTextOne.position.y = 3
    oddboyTextOne.position.z = -100
    oddboyTextOne.rotation.y = 3.14159
    oddboyTextOne.scale.y = 0.3
    oddboyTextOne.scale.x = 0.3
    scene.add oddboyTextOne
    TweenMax.to oddboyTextOne.position, 10,
      z: -8
      y: 4.2
      ease: Quart.easeOut

  loader.load "#{App.path}assets/objects/oddboy.json", (oddboyTextTwo) ->
    oddboyTextTwo.traverse (child) ->
      if child instanceof THREE.Mesh
        child.material = materialTwo
    oddboyTextTwo.position.x = 2
    oddboyTextTwo.position.y = 3
    oddboyTextTwo.position.z = -100
    oddboyTextTwo.rotation.y = 3.14159
    oddboyTextTwo.scale.y = 0.3
    oddboyTextTwo.scale.x = 0.3
    scene.add oddboyTextTwo
    TweenMax.to oddboyTextTwo.position, 10.3,
      z: -8.3
      y: 4.1
      ease: Quart.easeOut

  # Lights
  light = new (THREE.DirectionalLight)(0xffffff)
  light.position.set 2, 2, 4
  scene.add light
  light = new (THREE.DirectionalLight)(0xffffff)
  light.position.set -1, -1, -1
  scene.add light
  light = new (THREE.AmbientLight)(0x222222)
  scene.add light

  # Post processing effects
  composer = new (THREE.EffectComposer)(renderer)
  composer.addPass new (THREE.RenderPass)(scene, camera)
  msaaRenderPass = new (THREE.ManualMSAARenderPass)(scene, camera)
  msaaRenderPass.sampleLevel = param.MSAASampleLevel
  composer.addPass msaaRenderPass
  copyPass = new (THREE.ShaderPass)(THREE.CopyShader)
  copyPass.renderToScreen = true
  composer.addPass copyPass

  # Create stars
  geom = new (THREE.Geometry)
  createVertCloud geom
  createPartCloud geom
  window.addEventListener 'resize', onWindowResize, false

onWindowResize = ->
  width = window.innerWidth
  height = window.innerHeight
  windowHalfX = width / 2
  windowHalfY = height / 2
  camera.aspect = width / height
  camera.updateProjectionMatrix()
  renderer.setSize width, height
  pixelRatio = renderer.getPixelRatio()
  newWidth = Math.floor(width / pixelRatio) or 1
  newHeight = Math.floor(height / pixelRatio) or 1
  composer.setSize newWidth, newHeight
  msaaRenderPass.setSize newWidth, newHeight

onDocumentMouseMove = (event) ->
  mouseX = (event.clientX - windowHalfX) / 2
  mouseY = (event.clientY - windowHalfY) / 2

# Star cloud creation
createVertCloud = (emptyGeo) ->
  i = 0
  while i < 2200
    verts = new (THREE.Vector3)(fog: false)
    verts.x = Math.random() * 3000 - 2500
    verts.y = Math.random() * 3000 - 2500
    verts.z = Math.random() * 3000 - 2500
    emptyGeo.vertices.push verts
    i++

createPartCloud = (geo) ->
  THREE.ImageUtils.crossOrigin = ''
  mat = new (THREE.PointsMaterial)(
    size: 5
    transparent: true
    opacity: 0.1
    blending: 'AdditiveBlending'
    fog: false)
  particles = new (THREE.Points)(geo, mat)
  scene.add particles

# Render
animate = ->
  requestAnimationFrame animate
  render()

render = ->
  composer.render()
  camera.rotation.x = (-mouseY - (camera.rotation.x)) * .0002
  camera.rotation.y = (-mouseX - (camera.rotation.y)) * .0002

init()
animate()
document.addEventListener 'mousemove', onDocumentMouseMove, false
