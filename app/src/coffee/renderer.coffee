class Renderer
  constructor: (options) ->
    @$window = $(window)

    @path = options.path
    @instances = options.instances || []

    @windowHeight = options.windowHeight
    @windowWidth = options.windowWidth
    @smallBreakpoint = options.smallBreakpoint
    @mediumBreakpoint = options.mediumBreakpoint
    @isTouch = options.isTouch || false
    @skipLoader = options.skipLoader || false
    @primaryColor = options.primaryColor
    @accentColor = options.accentColor
    @secondaryColor = options.secondaryColor

    @exports = {}
    @controllers = options.controllers || []

    @lastScrollY = 0
    @ticking = false

  init: ->
    @exports.RendererController = @

    exports = @exports =
      parent: @
      path: @path
      instances: @instances
      windowWidth: @windowWidth
      windowHeight: @windowHeight
      smallBreakpoint: @smallBreakpoint
      mediumBreakpoint: @mediumBreakpoint
      isTouch: @isTouch
      skipLoader: @skipLoader
      primaryColor: @primaryColor
      accentColor: @accentColor
      secondaryColor: @secondaryColor

    controllers = @controllers
    controllers.sort (a, b) ->
      a.order - b.order

    for controller in controllers
      controller.build exports

    @$window
      .on 'resize', @onResize.bind @
      .trigger 'resize'
      .on 'scroll', @onScroll.bind @

  onUpdate: ->
    exports = @exports

    for controller in @controllers
      controller.onUpdate exports

  onResize: (e) ->
    exports = @exports
    exports.windowWidth = windowWidth = @$window.width()
    exports.windowHeight = @$window.height()

    exports.isSmall = windowWidth <= exports.smallBreakpoint
    exports.isMedium = exports.smallBreakpoint < windowWidth <= exports.mediumBreakpoint

    for controller in @controllers
      controller.onResize exports

  onScroll: (e) ->
    exports = @exports
    @lastScrollY = window.pageYOffset
    if not @ticking
      window.requestAnimationFrame =>
        for controller in @controllers
          controller.onScroll exports, @lastScrollY
        @ticking = false
    @ticking = true

App.Renderer = Renderer
