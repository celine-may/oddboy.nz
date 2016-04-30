class App.Home
  constructor: ->
    @order = 13

  build: (exports) ->
    exports.HomeController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    $navLink = $('.nav-link')

    $navLink.on 'mouseenter', (e) =>
      view = $(e.target).attr 'data-view'
      @$panel = App.getPanel view
      @direction = App.getDirection view
      @slidePanel exports, 42
      exports.glitch = true
    $navLink.on 'mouseleave', (e) =>
      @slidePanel exports, 15
      exports.glitch = false

  slidePanel: (exports, delta) ->
    TweenLite.to @$panel, .3,
      x: (exports.windowWidth - delta) * @direction
      ease: Power2.easeOut

  onUpdate: ->

  onResize: (exports) ->

  onScroll: (exports, scrollY) ->

App.Controllers.push new App.Home
