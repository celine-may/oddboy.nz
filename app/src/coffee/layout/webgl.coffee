class App.Webgl
  build: (exports) ->
    exports.WebglController = @
    exports.instances.push @

    @isLoaded = false
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
    @param = MSAASampleLevel: 2
    @ride = false
    @intersected = null

    @copyVisible = false

    @init exports

  init: (exports) ->
    $window = $(window)
    @$home = $('.view[data-view="home"]')

    THREE.DefaultLoadingManager.onProgress = (item, loaded, total) =>
      if loaded is total
        @scene.add @logo
        @isLoaded = true

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
      object.position.set -.4, 4.3, -9
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
    unless @isLoaded
      return

    logoTL = new TimelineLite()
    .to @camera.position, 2.7,
      y: 4.5
      z: 0
    .to @frontLogo.position, 4.3,
      y: 3.7
      z: -8
      ease: Quart.easeOut
    , .7
    .to @backLogo.position, 4.5,
      y: 3.6
      z: -8.3
      ease: Quart.easeOut
      onComplete: =>
        @ride = true
        if exports.view is 'home'
          exports.isAnimating = false
    , .8

  animateCopyIn: (exports) ->
    @copyVisible = true

    TweenLite.to @copyMaterial, .8,
      opacity: 1
      ease: Expo.easeOut
    TweenLite.to @copy.position, .8,
      y: 3.5
      ease: Expo.easeOut

  animateCopyOut: (exports) ->
    unless @copyVisible
      return

    TweenLite.to @copyMaterial, .8,
      opacity: 0
      ease: Expo.easeOut
    TweenLite.to @copy.position, .8,
      y: 4.3
      ease: Expo.easeOut
      onComplete: =>
        @copyVisible = false

  intersector: (e, exports) ->
    @mouse.set( (e.clientX / window.innerWidth ) * 2 - 1, - ( e.clientY / window.innerHeight ) * 2 + 1 )
    @raycaster.setFromCamera @mouse, @camera

    intersects = @raycaster.intersectObjects @logo.children, true

  moveLogo: (exports, e) ->
    mouseX = (e.clientX - exports.windowWidth) / 2
    mouseY = (exports.windowHeight - e.clientY) / 2

    frontX = 2 + (mouseX / exports.windowWidth) * 2 * .4
    frontY = 3.7 + (mouseY / exports.windowHeight) * 3.7 * .4
    backX = 2 + (mouseX / exports.windowWidth) * 2 * .5
    backY = 3.6 + (mouseY / exports.windowHeight) * 3.6 * .5

    frontRotationX = (e.clientY / exports.windowHeight) * -13
    backRotationX = (e.clientY / exports.windowHeight) * -13.1
    frontRotationY = (e.clientX / exports.windowWidth) * -13
    backRotationY = (e.clientX / exports.windowWidth) * -13.1

    @frontLogo.position.set frontX, frontY, -8
    @backLogo.position.set backX, backY, -8.3

    @frontLogo.rotation.set App.toRadians(frontRotationX), App.π + App.toRadians(frontRotationY), 0
    @backLogo.rotation.set App.toRadians(backRotationX), App.π + App.toRadians(backRotationY), 0

  onUpdate: (exports) ->
    if exports.glitch
      @glitchPass.goWild = true
      @glitchPass.renderToScreen = true
    else
      @glitchPass.renderToScreen = false

    @composer.render()

  onResize: (exports) ->
    vw = if @container then @container.offsetWidth else exports.windowWidth
    vh = if @container then @container.offsetHeight else exports.windowHeight
    renderW = Math.round(vw) - 20
    renderH = Math.round(vh)
    renderAspect = renderW / renderH
    if exports.width != renderW or exports.height != renderH
      exports.width = renderW
      exports.height = renderH
      exports.aspect = renderAspect

      @camera.aspect = renderAspect
      @camera.updateProjectionMatrix()
      @gl.setSize renderW, renderH
      pixelRatio = @gl.getPixelRatio()
      newWidth = Math.floor(renderW / pixelRatio) or 1
      newHeight = Math.floor(renderH / pixelRatio) or 1
      @composer.setSize newWidth, newHeight

  onMouseMove: (e, exports) ->
    if @ride
      intersects = @intersector e, exports
      if intersects.length > 0
        if @intersected != intersects[0].object.parent
          @intersected = intersects[0].object.parent
          @animateCopyIn exports
      else
        @intersected = null
        @animateCopyOut exports

      @moveLogo exports, e

# NOTES
# Commented the logo animation as it's quite buggy
# with the mouse movement animatoin
