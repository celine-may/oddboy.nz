class Renderer
  constructor: (options) ->
    @$window = $(window)

    @exports = {}
    @fxs = options.fxs || []

    @lastScrollY = 0
    @ticking = false

  init: ->
    exports = @exports =
      path: App.path
      controllers: []
      windowWidth: @$window.width()
      windowHeight: @$window.height()
      smallBreakpoint: 767
      mediumBreakpoint: 1023
      isTouch: Modernizr.touchevents
      showLoader: false
      primaryColor: '#23dcd4'
      accentColor: '#f83656'
      secondaryColor: '#0c1b33'

    exports.RendererController = @

    fxs = @fxs
    fxs.sort (a, b) ->
      a.order - b.order

    for fx in fxs
      fx.build exports

    # transition = new App.Transition
    # transition.init exports

    @$window
      .on 'resize', @onResize.bind @
      .trigger 'resize'
      .on 'scroll', @onScroll.bind @

  onResize: (e) ->
    exports = @exports
    exports.windowWidth = windowWidth = @$window.width()
    exports.windowHeight = @$window.height()

    exports.isSmall = windowWidth <= exports.smallBreakpoint
    exports.isMedium = exports.smallBreakpoint < windowWidth <= exports.mediumBreakpoint

    for fx in @fxs
      fx.onResize exports

  onScroll: (e) ->
    exports = @exports
    @lastScrollY = window.pageYOffset
    if not @ticking
      window.requestAnimationFrame =>
        for fx in @fxs
          fx.onScroll exports, @lastScrollY
        @ticking = false
    @ticking = true

App.Renderer = Renderer
