class Transition
  constructor: ->
    @order = 0
    @initBuild = true

  build: (exports) ->
    exports.TransitionController = @
    exports.instances.push @

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
      for view in exports.views
        direction = App.getDirection view
        TweenLite.set $(".view[data-view='#{view}']"),
          x: (exports.windowWidth - 20) * direction
      @$ui
        .find '.nav-link'
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
        overflowY: 'auto'
      TweenLite.set $(".view[data-view='#{@view}'] .header-content"),
        top: 0
        opacity: 1
      TweenLite.set @$slideUpElements,
        opacity: 1
        y: 0
      exports.isAnimating = false

  switchViewHandler: (exports) ->
    exports.isAnimating = true
    history.replaceState null, '', @newView
    exports.glitch = false
    if @view is 'home'
      @homeToView exports
    else if @newView is 'home'
      @viewToHome exports
    else
      @viewToView exports

  homeToView: (exports) ->
    $view = $(".view[data-view='#{@newView}']")
    $header = $view.find '.header-content'

    transitionTL = new TimelineLite()
    .to $view, .8,
      x: 0
      ease: Power3.easeInOut
    .to $header, 1.3,
      top: 0
      opacity: 1
      ease: Power3.easeInOut
    , '-=.7'
    .to @$slideUpElements, .8,
      opacity: 1
      y: 0
      ease: Power3.easeInOut
    , '-=.2'
    .call =>
      App.stopMainLoop()
      @setView exports, @newView
    , null, null, .4
    .call ->
      exports.isAnimating = false
      $view.css 'overflow-y', 'auto'
    , null, null, '+=.2'

  viewToHome: (exports) ->
    $view = $(".view[data-view='#{@view}']")
    $header = $view.find '.header-content'

    direction = App.getDirection @view

    App.startMainLoop()

    transitionTL = new TimelineLite()
    .to $view, .8,
      x: (exports.windowWidth - 20) * direction
      ease: Power3.easeInOut
    .to $header, 1.3,
      top: 100
      ease: Power3.easeInOut
    , '-=.8'
    .set @$ui,
      zIndex: exports.zTop + 1
    .to @$slideUpElements, .4,
      opacity: 1
      y: 0
      ease: Power3.easeInOut
    , '-=.2'
    .set @$ui,
      zIndex: exports.zXTop
    .set $view,
      overflowY: 'hidden'
    .call =>
      @setView exports, @newView
    , null, null, .3
    .call ->
      $view.scrollTop 0
      exports.isAnimating = false
    , null, null, '+=.2'

  viewToView: (exports) ->
    $view = $(".view[data-view='#{@view}']")
    $header = $view.find '.header-content'
    $newView  = $(".view[data-view='#{@newView}']")
    $newHeader = $newView.find '.header-content'

    direction = App.getDirection @view

    transitionTL = new TimelineLite()
    .to $view, .8,
      x: exports.windowWidth * direction
      ease: Power3.easeInOut
    .to $header, 1.3,
      top: 100
      ease: Power3.easeInOut
    , '-=.8'
    .to $newView, .8,
      x: 0
      ease: Power3.easeInOut
    , '-=1.3'
    .to $newHeader, 1.3,
      top: 0
      opacity: 1
      ease: Power3.easeInOut
    , '-=1.3'
    .call =>
      @setView exports, @newView
    , null, null, .3
    .call ->
      $newView.scrollTop 0
      $newView.css 'overflow-y', 'auto'
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
