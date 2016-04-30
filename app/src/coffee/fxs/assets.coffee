class App.Assets
  constructor: ->
    @order = 1
    @name = 'assets'

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
    $body = $('body')

    $window.on 'mousemove', (e) =>
      @onMouseMove e, exports

    # Create webgl frame
    $webglFrame = $('<div class="webgl-frame"></div>')
    $body.prepend $webglFrame

    # Create scene
    scene = @scene = new THREE.Scene
    scene.fog = new THREE.FogExp2 0x020711, 0.03

    # Webgl Renderer
    gl = @gl = new THREE.WebGLRenderer antialias: false
    gl.setClearColor scene.fog.color
    gl.setPixelRatio window.devicePixelRatio
    gl.setSize window.innerWidth, window.innerHeight
    $webglFrame[0].appendChild gl.domElement

    # Create camera
    camera = @camera = new THREE.PerspectiveCamera 60, window.innerWidth / window.innerHeight, 0.1, 1000
    camera.position.set 2, 4.5, 0

    # Create Grid
    grid = new THREE.GridHelper 500, 4
    color = new THREE.Color 'rgb(250,71,100)'
    grid.setColors color, 0xfa4764
    scene.add grid
    TweenMax.to grid.position, 20, z: 300

    # Load objects (oddboy)
    material = new THREE.MeshPhongMaterial color: 0x26e2e3
    materialTwo = new THREE.MeshPhongMaterial color: 0xf8465e
    loader = new THREE.ObjectLoader
    loader.load "#{exports.path}assets/json/oddboy-logo.json", (oddboyTextOne) ->
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

    loader.load "#{exports.path}assets/json/oddboy-logo.json", (oddboyTextTwo) ->
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
    light = new THREE.DirectionalLight 0xffffff
    light.position.set 2, 2, 4
    scene.add light
    light = new THREE.DirectionalLight 0xffffff
    light.position.set -1, -1, -1
    scene.add light
    light = new THREE.AmbientLight 0x222222
    scene.add light

    # Post processing effects
    composer = @composer = new THREE.EffectComposer gl
    composer.addPass new THREE.RenderPass scene, camera
    msaaRenderPass = @msaaRenderPass = new THREE.ManualMSAARenderPass scene, camera
    msaaRenderPass.sampleLevel = @param.MSAASampleLevel
    composer.addPass msaaRenderPass
    copyPass = new THREE.ShaderPass THREE.CopyShader
    copyPass.renderToScreen = true
    composer.addPass copyPass

    # Create stars
    geom = new THREE.Geometry
    @createVertCloud geom
    @createPartCloud geom

  createVertCloud: (emptyGeo) ->
    i = 0
    while i < 2200
      verts = new THREE.Vector3 fog: false
      verts.x = Math.random() * 3000 - 2500
      verts.y = Math.random() * 3000 - 2500
      verts.z = Math.random() * 3000 - 2500
      emptyGeo.vertices.push verts
      i++

  createPartCloud: (geo) ->
    THREE.ImageUtils.crossOrigin = ''
    mat = new THREE.PointsMaterial
      size: 5
      transparent: true
      opacity: 0.1
      blending: 'AdditiveBlending'
      fog: false
    particles = new THREE.Points geo, mat
    @scene.add particles

  onUpdate: (exports) ->
    composer = @composer
    camera = @camera

    composer.render()
    camera.rotation.x = (-@mouseY - (camera.rotation.x)) * .0002
    camera.rotation.y = (-@mouseX - (camera.rotation.y)) * .0002

  onResize: (exports) ->
    camera = @camera
    gl = @gl
    composer = @composer
    msaaRenderPass = @msaaRenderPass

    c = @container
    vw = if c then c.offsetWidth else window.innerWidth
    vh = if c then c.offsetHeight else window.innerHeight
    renderW = Math.round vw
    renderH = Math.round vh
    if exports.width != renderW or exports.height != renderH
      exports.width = renderW
      exports.height = renderH

      camera.aspect = renderW / renderH
      camera.updateProjectionMatrix()

      gl.setSize renderW, renderH
      pixelRatio = gl.getPixelRatio()
      newWidth = Math.floor(renderW / pixelRatio) or 1
      newHeight = Math.floor(renderH / pixelRatio) or 1
      composer.setSize newWidth, newHeight
      # msaaRenderPass.setSize newWidth, newHeight

  onMouseMove: (e, exports) ->
    windowHalfX = exports.windowWidth / 2
    windowHalfY = exports.windowHeight / 2

    @mouseX = (e.clientX - windowHalfX) / 2
    @mouseY = (e.clientY - windowHalfY) / 2

  onScroll: ->


App.Controllers.push new App.Assets
