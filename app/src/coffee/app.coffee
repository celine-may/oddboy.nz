$ ->
  $window = $(window)
  $body = $('body')

  # OS detection
  unless navigator.appVersion.indexOf('Mac') is -1
    $('html').addClass 'is-mac'

  # Email replacement
  for element in $('.do-replace-email')
    App.replaceEmail $(element)

  renderer = new App.Renderer
    controllers: App.Controllers
    path: App.path
    instances: []
    windowWidth: $window.width()
    windowHeight: $window.height()
    mediumBreakpoint: 1023
    smallBreakpoint: 767
    isTouch: Modernizr.touchevents
    skipLoader: true
    primaryColor: '#23dcd4'
    accentColor: '#f83656'
    secondaryColor: '#0c1b33'

  renderer.init()
  App.renderer = renderer

  # Core
  startMainLoop = ->
    renderer.exports.frame = undefined
    mainLoop()
  App.startMainLoop = startMainLoop

  stopMainLoop = ->
    cancelAnimationFrame renderer.exports.frame
    renderer.exports.frame = undefined
  App.stopMainLoop = stopMainLoop

  mainLoop = ->
    renderer.exports.frame = requestAnimationFrame mainLoop
    renderer.onUpdate()

  startMainLoop()
