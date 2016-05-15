class Home
  constructor: ->
    @order = 10
    @initBuild = false

  build: (exports) ->
    exports.HomeController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    $navLink = $('.nav-link')

    unless exports.view is 'home'
      return

    $navLink.on 'mouseenter', (e) =>
      if exports.isAnimating
        return

      view = $(e.target).attr 'data-view'
      @$view = $(".view[data-view='#{view}']")
      @direction = App.getDirection view
      @viewSneakPeek exports, 42
      exports.glitch = true

    $navLink.on 'mouseleave', (e) =>
      if exports.isAnimating
        return

      @viewSneakPeek exports, 15
      exports.glitch = false

  viewSneakPeek: (exports, delta) ->
    TweenLite.to @$view, .3,
      x: (exports.windowWidth - delta) * @direction
      ease: Power2.easeOut

  onResize: (exports) ->
    if exports.view is 'home'
      for view in exports.views
        direction = App.getDirection view
        TweenLite.set $(".view[data-view='#{view}']"),
          x: (exports.windowWidth - 15) * direction

App.Controllers.push new Home
