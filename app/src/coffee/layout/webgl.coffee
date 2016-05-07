class App.Assets
  constructor: ->
    @order = 1

  build: (exports) ->
    exports.AssetsController = @
    exports.instances.push @

    @camera = undefined
    @scene = undefined
    @gl = undefined
    @frontLogo = undefined
    @backLogo = undefined
    @copy = undefined
    @composer = undefined
    @copyPass = undefined
    @msaaRenderPass = undefined
    @logo = new THREE.Object3D()
    @logoHelper = undefined
    @param = MSAASampleLevel: 2
    @animatedIn = false
    @intersected = null

    @copyVisible = false
    @ride = false

    @mouseX = 0
    @mouseY = 0

    @init exports

  init: (exports) ->
    $window = $(window)
    @$home = $('.view[data-view="home"]')

    THREE.DefaultLoadingManager.onProgress = (item, loaded, total) =>
      if loaded is total
        @scene.add @logo

        @animateIn exports

    @createScene exports
    @createGL exports
    @createCamera exports
    @createGrid exports
    @createLights exports
    @createStars exports
    @addObjects exports
    @postProcessing exports

    @mouse = new THREE.Vector2()
    @raycaster = new THREE.Raycaster()

    $window.on 'mousemove', (e) =>
      @onMouseMove e, exports

  createScene: (exports) ->
    @scene = new THREE.Scene
    @scene.fog = new THREE.FogExp2 0x020711, 0.03

  createGL: (exports) ->
    $webglFrame = $('<div class="webgl-frame"></div>')
    @$home.prepend $webglFrame

    @gl = new THREE.WebGLRenderer antialias: false
    @gl.setClearColor @scene.fog.color
    @gl.setPixelRatio window.devicePixelRatio
    @gl.setSize exports.windowWidth, exports.windowHeight
    $webglFrame[0].appendChild @gl.domElement

  createCamera: (exports) ->
    @camera = new THREE.PerspectiveCamera 60, exports.windowWidth / exports.windowHeight, 0.1, 1000
    @camera.position.set 2, 70, 500

  addObjects: (exports) ->
    frontMaterial = new THREE.MeshPhongMaterial
      color: exports.primaryColor
    backMaterial = new THREE.MeshPhongMaterial
      color: exports.accentColor
    copyMaterial = @copyMaterial = new THREE.MeshPhongMaterial
      color: exports.accentColor
      transparent: true
      # opacity: 1

    loader = new THREE.ObjectLoader
    loader.load "#{exports.path}assets/json/oddboy-logo.json", (object) =>
      @frontLogo = object
      object.name = 'Front Logo'
      object.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = frontMaterial
      object.position.set 2, 3, -100
      object.rotation.y = App.π
      object.scale.set .3, .3, .3
      @logo.add object

    loader.load "#{exports.path}assets/json/oddboy-logo.json", (object) =>
      @backLogo = object
      object.name = 'Back Logo'
      object.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = backMaterial
      object.position.set 2, 3, -100
      object.rotation.y = App.π
      object.scale.set .3, .3, .3
      @logo.add object

    loader.load "#{exports.path}assets/json/oddboy-copy.json", (object) =>
      @copy = object
      object.name = 'Copy'
      object.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = copyMaterial
      object.position.set -.4, 4.3, -7
      object.rotation.y = App.π
      object.scale.set .2, .2, .2
      copyMaterial.opacity = 0
      @scene.add object

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

  createLights: (exports) ->
    light = new THREE.DirectionalLight 0xffffff
    light.position.set 2, 2, 4
    @scene.add light
    light = new THREE.DirectionalLight 0xffffff
    light.position.set -1, -1, -1
    @scene.add light
    light = new THREE.AmbientLight 0x222222
    @scene.add light

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

  postProcessing: (exports) ->
    composer = @composer = new THREE.EffectComposer @gl
    composer.addPass new THREE.RenderPass @scene, @camera
    msaaRenderPass = @msaaRenderPass = new THREE.ManualMSAARenderPass @scene, @camera
    msaaRenderPass.sampleLevel = @param.MSAASampleLevel
    composer.addPass msaaRenderPass
    copyPass = new THREE.ShaderPass THREE.CopyShader
    copyPass.renderToScreen = true
    composer.addPass copyPass
    glitchPass = @glitchPass = new THREE.GlitchPass()
    composer.addPass glitchPass

  animateIn: (exports) ->
    logoTL = new TimelineLite()
    .to @camera.position, 1,
      y: 4.5
      z: 0
    .to @frontLogo.position, 1,
      y: 4.2
      z: -8
      ease: Quart.easeOut
    , '-=1'
    .to @backLogo.position, 1.2,
      y: 4.1
      z: -8.3
      ease: Quart.easeOut
      onComplete: =>
        @animatedIn = true
        @ride = true
    , '-=10'

  animateCopyIn: (exports) ->
    @copyVisible = true
    @ride = false

    TweenLite.to @copyMaterial, .8,
      opacity: 1
      ease: Expo.easeOut
    TweenLite.to @copy.position, .8,
      y: 4.1
      ease: Expo.easeOut
    TweenLite.to @frontLogo.position, .8,
      y: 4.88
      ease: Expo.easeInOut
    TweenLite.to @backLogo.position, .8,
      y: 4.77
      ease: Expo.easeInOut

  animateCopyOut: (exports) ->
    unless @copyVisible
      return

    TweenLite.to @copyMaterial, .8,
      opacity: 0
      ease: Expo.easeOut
    TweenLite.to @copy.position, .8,
      y: 4.3
      ease: Expo.easeOut
    TweenLite.to @frontLogo.position, .8,
      y: 4.18
      ease: Expo.easeInOut
    TweenLite.to @backLogo.position, .8,
      y: 4.07
      ease: Expo.easeInOut

    setTimeout =>
      @copyVisible = false
      @ride = true
    , 800

  intersector: (e, exports) ->
    @mouse.set( (e.clientX / window.innerWidth ) * 2 - 1, - ( e.clientY / window.innerHeight ) * 2 + 1 )
    @raycaster.setFromCamera @mouse, @camera

    intersects = @raycaster.intersectObjects @logo.children, true

  onUpdate: (exports) ->
    if exports.glitch
      @glitchPass.renderToScreen = true
    else
      @glitchPass.renderToScreen = false

    @composer.render()
    # @camera.rotation.x = (-@mouseY - (@camera.rotation.x)) * .0002
    # @camera.rotation.y = (-@mouseX - (@camera.rotation.y)) * .0002

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

    if @animatedIn
      intersects = @intersector e, exports
      if intersects.length > 0
        if @intersected != intersects[0].object.parent
          @intersected = intersects[0].object.parent
          @animateCopyIn exports
      else
        @intersected = null
        @animateCopyOut exports

    if @ride
      deltaX = @mouseX / exports.windowWidth
      deltaY = @mouseY / exports.windowHeight

      @frontLogo.position.set 2 + 2 * deltaX * .2, 4.2 + 4.2 * deltaY * .2, -8
      @backLogo.position.set 2 + 2 * deltaX * .3, 4.1 + 4.1 * deltaY * .3, -8.3

  onScroll: ->


App.Controllers.push new App.Assets
