class Renderer
  constructor: (options) ->
    @$window = $(window)

    @path = options.path
    @cdnPath = options.cdnPath
    @instances = options.instances || []

    @windowHeight = options.windowHeight
    @windowWidth = options.windowWidth
    @smallBreakpoint = options.smallBreakpoint
    @mediumBreakpoint = options.mediumBreakpoint
    @views = options.views
    @isAnimating = options.isAnimating
    @isTouch = options.isTouch || false
    @skipLoader = options.skipLoader || false
    @primaryColor = options.primaryColor
    @accentColor = options.accentColor
    @secondaryColor = options.secondaryColor
    @zHidden = options.zHidden
    @zBase = options.zBase
    @zTop = options.zTop
    @zXTop = options.zXTop

    @exports = {}
    @controllers = options.controllers || []

  init: ->
    exports = @exports =
      RendererController: @
      path: @path
      cdnPath: @cdnPath
      instances: @instances
      windowWidth: @windowWidth
      windowHeight: @windowHeight
      smallBreakpoint: @smallBreakpoint
      mediumBreakpoint: @mediumBreakpoint
      views: @views
      isAnimating: @isAnimating
      isTouch: @isTouch
      skipLoader: @skipLoader
      primaryColor: @primaryColor
      accentColor: @accentColor
      secondaryColor: @secondaryColor
      zHidden: @zHidden
      zBase: @zBase
      zTop: @zTop
      zXTop: @zXTop

    @webgl = new App.Webgl
    @webgl.build exports

    controllers = @controllers
    controllers.sort (a, b) ->
      a.order - b.order

    for controller in controllers
      if controller.initBuild
        controller.build exports

    @$window
      .on 'resize', @onResize.bind @
      .trigger 'resize'

  delayedBuild: (exports) ->
    for controller in @controllers
      unless controller.initBuild
        controller.build exports

  getCurrentBreakpoint: (exports) ->
    if exports.isSmall
      'small'
    else if exports.isMedium
      'medium'
    else
      'large'

  onUpdate: ->
    @webgl.onUpdate @exports

  onResize: (e) ->
    exports = @exports
    exports.windowWidth = windowWidth = @$window.width()
    exports.windowHeight = @$window.height()

    exports.isSmall = windowWidth <= exports.smallBreakpoint
    exports.isMedium = exports.smallBreakpoint < windowWidth <= exports.mediumBreakpoint
    exports.currentBreakpoint = @getCurrentBreakpoint(exports)

    @webgl.onResize exports

    for controller in @controllers
      controller.onResize exports

App.Renderer = Renderer
