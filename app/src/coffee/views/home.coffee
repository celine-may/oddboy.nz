class Home
  constructor: ->
    @order = 10

    @initiated = false

  build: (exports) ->
    exports.HomeController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    $navLink = $('.nav-link')
    @$showProjectDetailsElement = $('.do-show-project-details')

    unless exports.view is 'home' or @initiated
      return

    @initiated = true

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

  viewSneakPeek: (exports, delta) ->
    TweenLite.to @$view, .3,
      x: (exports.windowWidth - delta) * @direction
      ease: Power2.easeOut

  onResize: (exports) ->

App.Controllers.push new Home
