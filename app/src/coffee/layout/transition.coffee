class Transition
  constructor: ->
    @order = 0
    @initBuild = true

  build: (exports) ->
    exports.TransitionController = @
    exports.instances.push @

    @views = [ 'what-we-do', 'talk-to-us' ]
    @view = undefined
    @newView = undefined

    @init exports

  init: (exports) ->
    @$window = $(window)
    @$main = $('.main')
    @$ui = $('.ui')

    @$showViewBtn = $('.do-show-view')
    @$slideUpElements = $('.do-slide-up')

    @exports = exports

    @setView exports

    @setInitialView exports

    @$showViewBtn.on 'click', (e) =>
      $btn = $(e.target)
      unless $btn.hasClass 'do-show-view'
        $btn = $btn.parents '.do-show-view'
      @newView = $btn.attr 'data-view'
      @switchViewHandler exports

  setInitialView: (exports) ->
    if @view is 'home'
      for view in @views
        direction = App.getDirection view
        TweenLite.set $(".view[data-view='#{view}']"),
          x: exports.windowWidth * direction
      @$ui
        .find '.do-slide-up'
        .css
          opacity: 1
          y: 0
    else
      oppositeView = App.getOppositeView @view
      direction = App.getDirection oppositeView
      TweenLite.set $(".view[data-view='#{oppositeView}']"),
        x: exports.windowWidth * direction
      TweenLite.set $(".view[data-view='#{@view}']"),
        x: 0
      TweenLite.set @$slideUpElements,
        opacity: 1
        y: 0

  switchViewHandler: (exports) ->
    exports.isAnimating = true
    history.replaceState null, '', @newView
    if @view is 'home'
      @homeToView exports
    else if @newView is 'home'
      @viewToHome exports
    else
      @viewToView exports

  homeToView: (exports) ->
    $view = $(".view[data-view='#{@newView}']")

    transitionTL = new TimelineLite()
    .to $view, .6,
      x: 0
      ease: Power3.easeIn
    .to @$slideUpElements, .2,
      opacity: 0
      y: 20
      ease: Power3.easeOut
    , '-=.4'
    .to @$slideUpElements, .4,
      opacity: 1
      y: 0
      ease: Power3.easeIn
    , '-=.2'
    .call =>
      App.stopMainLoop()
      @setView exports, @newView
    , null, null, .3
    .call ->
      exports.isAnimating = false
    , null, null, '+=.2'

  viewToHome: (exports) ->
    $view = $(".view[data-view='#{@view}']")

    direction = App.getDirection @view

    App.startMainLoop()

    transitionTL = new TimelineLite()
    .to $view, .6,
      x: (exports.windowWidth - 15) * direction
      ease: Power3.easeIn
    .set @$ui,
      zIndex: exports.zTop + 1
    .to @$slideUpElements, .4,
      opacity: 1
      y: 0
      ease: Power3.easeIn
    , '-=.2'
    .set @$ui,
      zIndex: exports.zXTop
    .call =>
      @setView exports, @newView
    , null, null, .3
    .call ->
      exports.isAnimating = false
    , null, null, '+=.2'

  viewToView: (exports) ->
    $view = $(".view[data-view='#{@view}']")
    $newView  = $(".view[data-view='#{@newView}']")

    direction = App.getDirection @view

    transitionTL = new TimelineLite()
    .to $view, .6,
      x: exports.windowWidth * direction
      ease: Power3.easeIn
    .to $newView, .6,
      x: 0
      ease: Power3.easeIn
    , '-=.6'
    .call =>
      @setView exports, @newView
    , null, null, .3
    .call ->
      exports.isAnimating = false
    , null, null, '+=.2'

  setView: (exports, newView = null) ->
    unless newView?
      uriArray = window.location.href.split('/')
      newView = uriArray[uriArray.length-1]
      if newView is ''
        newView = 'home'

    @view = exports.view = newView
    @newView = undefined
    @$main.attr 'data-view', @view

    if exports.ScrollController?
      exports.ScrollController.init exports

  onResize: (exports) ->

App.Controllers.push new Transition
