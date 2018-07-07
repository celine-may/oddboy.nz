class Home
  constructor: ->
    @order = 10
    @initBuild = false

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

    @$showProjectDetailsElement.on 'mouseenter', (e) =>
      if exports.isAnimating
        return
      @showProjectDetails e

    @$showProjectDetailsElement.on 'mouseleave', @hideProjectDetails

  viewSneakPeek: (exports, delta) ->
    TweenLite.to @$view, .3,
      x: (exports.windowWidth - delta) * @direction
      ease: Power2.easeOut

  showProjectDetails: (e) =>
    $element = $(e.target).parents '.project-card'
    $overlay = $element.find '.project-overlay'
    $title = $element.find '.project-title'
    $lead = $element.find '.project-lead'
    $arrow = $element.find '.project-arrow'

    @projectDetailsTL = new TimelineLite()
    .to $overlay, .2,
      opacity: .25
      ease: Power2.easeInOut
    .to $title, .5,
      y: 0
      ease: Power2.easeInOut
    , '-=.4'
    .to [$lead, $arrow], .6,
      opacity: 1
      y: 0
      ease: Power2.easeInOut
    , '-=.5'

  hideProjectDetails: =>
    @projectDetailsTL.reverse()

  onResize: (exports) ->

App.Controllers.push new Home
