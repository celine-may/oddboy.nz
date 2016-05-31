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
    @logo = new THREE.Object3D()
    @hitTest = new THREE.Object3D()
    @ride = false
    @intersected = null

    @copyVisible = false

    @init exports

  init: (exports) ->
    $window = $(window)
    @$home = $('.view[data-view="home"]')
    if exports.windowWidth > exports.smallBreakpoint
      @z = -8
    else
      @z = -17

    THREE.DefaultLoadingManager.onProgress = (item, loaded, total) =>
      if loaded is total
        @scene.add @logo
        @scene.add @hitTest
        @isLoaded = true

    @createScene exports
    @createGL exports
    @createCamera exports
    @createGrid exports
    @createLights exports
    @createStars exports
    @addObjects exports

    @mouse = new THREE.Vector2()
    @raycaster = new THREE.Raycaster()

    $window.on 'mousemove', (e) =>
      if exports.isTouch
        return

      @onMouseMove e, exports

  createScene: (exports) ->
    @scene = new THREE.Scene
    @scene.fog = new THREE.FogExp2 0x0a1527, 0.03

  createGL: (exports) ->
    $webglFrame = $('<div class="webgl-frame"></div>')
    @$home.prepend $webglFrame

    @gl = new THREE.WebGLRenderer antialias: true
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
    planeMaterial = new THREE.MeshBasicMaterial
      color: 0x0a1527
      transparent: true

    loader = new THREE.ObjectLoader
    loader.load "#{exports.path}assets/json/oddboy-logo.json", (object) =>
      @frontLogo = object
      object.name = 'Front Logo'
      object.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = frontMaterial
      object.position.set 2, 3.7, -8
      object.rotation.y = App.π
      object.scale.set .3, .3, .3
      @logo.add object

    loader.load "#{exports.path}assets/json/oddboy-logo.json", (object) =>
      @backLogo = object
      object.name = 'Back Logo'
      object.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = backMaterial
      object.position.set 2, 3.62, -8.3
      object.rotation.y = App.π
      object.scale.set .3, .3, .3
      @logo.add object

    loader.load "#{exports.path}assets/json/oddboy-copy.json", (object) =>
      @copy = object
      object.name = 'Copy'
      object.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = copyMaterial
      object.position.set -2, 3.6, -9
      object.rotation.y = App.π
      object.scale.set .33, .33, .33
      copyMaterial.opacity = 0
      @scene.add object

    geometry = new THREE.PlaneGeometry( 9, 2, 2 )
    plane = new THREE.Mesh( geometry, planeMaterial )
    plane.position.set 1.8, 4.5, -7
    planeMaterial.opacity = 0
    @hitTest.add plane

    @ride = true

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

  animateIn: (exports) ->
    unless @isLoaded
      return

    logoTL = new TimelineLite()
    .to @camera.position, 4.5,
      y: 4.5
      z: 0
      ease: Quart.easeOut
      onComplete: =>
        if exports.view is 'home'
          exports.isAnimating = false

  animateCopyIn: (exports) ->
    @copyVisible = true

    TweenLite.to @copyMaterial, .7,
      opacity: 1
      ease: Expo.easeInOut
    TweenLite.to @copy.position, .7,
      y: 3
      ease: Expo.easeInOut

  animateCopyOut: (exports) ->
    unless @copyVisible
      return

    TweenLite.to @copyMaterial, .4,
      opacity: 0
    TweenLite.to @copy.position, .8,
      y: 3.6
      onComplete: =>
        @copyVisible = false

  intersector: (e, exports) ->
    @mouse.set( (e.clientX / window.innerWidth ) * 2 - 1, - ( e.clientY / window.innerHeight ) * 2 + 1 )
    @raycaster.setFromCamera @mouse, @camera

    intersects = @raycaster.intersectObjects @hitTest.children, true

  moveLogo: (exports, e) ->
    mouseX = (e.clientX - exports.windowWidth*0.5) / 2
    mouseY = (e.clientY - exports.windowHeight*0.5) / 2

    @camera.rotation.x = (mouseY - @camera.rotation.x ) * -.0001
    @camera.rotation.y = (mouseX - @camera.rotation.y ) * -.00015

    frontX = 2 + (mouseX / exports.windowWidth) * 2 * .9
    frontY = 3.7 + (- mouseY / exports.windowHeight) * 3.7 * .33
    backX = 2 + (mouseX / exports.windowWidth) * 2 * .8
    backY = 3.6 + (- mouseY / exports.windowHeight) * 3.6 * .3

    @frontLogo.position.set frontX, frontY, -8
    @backLogo.position.set backX, backY, -8.3

  onUpdate: (exports) ->
    @gl.render @scene, @camera

  onResize: (exports) ->
    if exports.windowWidth > exports.smallBreakpoint
      delta = 20
      @z = -8
    else
      delta = 0
      @z = -17

    vw = if @container then @container.offsetWidth else exports.windowWidth
    vh = if @container then @container.offsetHeight else exports.windowHeight
    renderW = Math.round(vw) - delta
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
