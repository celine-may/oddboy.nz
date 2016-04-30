class App.Assets
  constructor: ->
    @order = 1

    @camera = undefined
    @scene = undefined
    @gl = undefined
    @mat = undefined
    @geom = undefined
    @composer = undefined
    @copyPass = undefined
    @msaaRenderPass = undefined
    @param = MSAASampleLevel: 2

    @mouseX = 0
    @mouseY = 0

  build: (exports) ->
    exports.AssetsController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    $window = $(window)
    @$body = $('body')

    @createScene exports
    @createGL exports
    @createCamera exports
    @createGrid exports
    @createLogo exports
    @createLights exports
    @postProcessing exports
    @createStars exports

    $window.on 'mousemove', (e) =>
      @onMouseMove e, exports

  createScene: (exports) ->
    @scene = new THREE.Scene
    @scene.fog = new THREE.FogExp2 0x020711, 0.03

  createGL: (exports) ->
    $webglFrame = $('<div class="webgl-frame"></div>')
    @$body.prepend $webglFrame

    @gl = new THREE.WebGLRenderer antialias: false
    @gl.setClearColor @scene.fog.color
    @gl.setPixelRatio window.devicePixelRatio
    @gl.setSize exports.windowWidth, exports.windowHeight
    $webglFrame[0].appendChild @gl.domElement

  createCamera: (exports) ->
    @camera = new THREE.PerspectiveCamera 60, exports.windowWidth / exports.windowHeight, 0.1, 1000
    @camera.position.set 2, 4.5, 0

  createGrid: (exports) ->
    grid = new THREE.GridHelper 500, 4
    grid.setColors exports.accentColor, exports.accentColor
    @scene.add grid

    gridTL = new TimelineLite()
    .to grid.position, 20,
      z: 300
      ease: Power0.easeNone
      onComplete: ->
        gridTL.restart()

  createLogo: (exports) ->
    frontMaterial = new THREE.MeshPhongMaterial color: exports.primaryColor
    backMaterial = new THREE.MeshPhongMaterial color: exports.accentColor

    loader = new THREE.ObjectLoader
    loader.load "#{exports.path}assets/json/oddboy-logo.json", (frontTexture) =>
      frontTexture.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = frontMaterial
      frontTexture.position.set 2, 3, -100
      frontTexture.rotation.y = App.π
      frontTexture.scale.set .3, .3, .3
      @scene.add frontTexture
      TweenMax.to frontTexture.position, 10,
        z: -8
        y: 4.2
        ease: Quart.easeOut

    loader.load "#{exports.path}assets/json/oddboy-logo.json", (backTexture) =>
      backTexture.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = backMaterial
      backTexture.position.set 2, 3, -100
      backTexture.rotation.y = App.π
      backTexture.scale.set .3, .3, .3
      @scene.add backTexture
      TweenMax.to backTexture.position, 10.3,
        z: -8.3
        y: 4.1
        ease: Quart.easeOut

  createLights: (exports) ->
    light = new THREE.DirectionalLight 0xffffff
    light.position.set 2, 2, 4
    @scene.add light
    light = new THREE.DirectionalLight 0xffffff
    light.position.set -1, -1, -1
    @scene.add light
    light = new THREE.AmbientLight 0x222222
    @scene.add light

  postProcessing: (exports) ->
    composer = @composer = new THREE.EffectComposer @gl
    composer.addPass new THREE.RenderPass @scene, @camera
    msaaRenderPass = @msaaRenderPass = new THREE.ManualMSAARenderPass @scene, @camera
    msaaRenderPass.sampleLevel = @param.MSAASampleLevel
    composer.addPass msaaRenderPass
    copyPass = new THREE.ShaderPass THREE.CopyShader
    copyPass.renderToScreen = true
    composer.addPass copyPass

  createStars: (exports) ->
    geometry = new THREE.Geometry
    @createVertCloud geometry
    @createPartCloud geometry

  createVertCloud: (geometry) ->
    i = 0
    while i < 2200
      verts = new THREE.Vector3 fog: false
      verts.x = Math.random() * 3000 - 2500
      verts.y = Math.random() * 3000 - 2500
      verts.z = Math.random() * 3000 - 2500
      geometry.vertices.push verts
      i++

  createPartCloud: (geometry) ->
    THREE.ImageUtils.crossOrigin = ''
    material = new THREE.PointsMaterial
      size: 5
      transparent: true
      opacity: 0.1
      blending: 'AdditiveBlending'
      fog: false
    particles = new THREE.Points geometry, material
    @scene.add particles

  onUpdate: (exports) ->
    @composer.render()
    @camera.rotation.x = (-@mouseY - (@camera.rotation.x)) * .0002
    @camera.rotation.y = (-@mouseX - (@camera.rotation.y)) * .0002

  onResize: (exports) ->
    vw = if @container then @container.offsetWidth else exports.windowWidth
    vh = if @container then @container.offsetHeight else exports.windowHeight
    renderW = Math.round vw
    renderH = Math.round vh
    if exports.width != renderW or exports.height != renderH
      exports.width = renderW
      exports.height = renderH

      @camera.aspect = renderW / renderH
      @camera.updateProjectionMatrix()

      @gl.setSize renderW, renderH
      pixelRatio = @gl.getPixelRatio()
      newWidth = Math.floor(renderW / pixelRatio) or 1
      newHeight = Math.floor(renderH / pixelRatio) or 1
      @composer.setSize newWidth, newHeight
      # @msaaRenderPass.setSize newWidth, newHeight

  onMouseMove: (e, exports) ->
    windowHalfX = exports.windowWidth / 2
    windowHalfY = exports.windowHeight / 2

    @mouseX = (e.clientX - windowHalfX) / 2
    @mouseY = (e.clientY - windowHalfY) / 2

  onScroll: ->


App.Controllers.push new App.Assets
