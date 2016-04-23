class Transition
  constructor: (options) ->
    @initiated = false

  init: (exports) ->
    @$window = $(window)
    @$main = $('#main')

    @exports = exports

    @setView exports, window.location.href

    options =
      prefetch: true
      cacheLength: 2
      onBefore: ($currentTarget, $container) =>
        @newView = $currentTarget.attr 'data-view'
      onStart:
        duration: 600
        render: ($container) =>
          if @view is 'home' and @newView is 'what-we-do'
            @showPanel 'lhs'
          if @view is 'home' and @newView is 'talk-to-us'
            @showPanel 'rhs'
      onReady:
        duration: 1200
        render: ($container, $newContent) =>
          $container.html $newContent
          @transitionIn exports
          @setView exports, smoothState.href
      onAfter: ($container, $newContent) =>
        @initFX @exports

    smoothState = @$main.smoothState(options).data 'smoothState'

    @initialTransition exports

  initialTransition: (exports) ->
    if @initiated
      return
    if exports.showLoader
      exports.LoaderController.playDevice exports
      exports.LoaderController.fillLoader exports
    @transitionIn exports
    @initiated = true

  showPanel: (panel) ->
    panelTL = new TimelineLite()
    .set $('.ui'),
      zIndex: 0
    .to $(".panel.#{panel}"), .6,
      x: 0
      ease: Power3.easeIn

  transitionIn: (exports) ->
    $slideIn = $('.do-slide-in')
    $slideUp = $('.do-slide-up')

    transitionInTL = new TimelineLite()
    .to $slideIn, .6,
      opacity: 1
      x: 0
      ease: Power3.easeInOut
    .to $slideUp, .8,
      opacity: 1
      y: 0
      ease: Power3.easeIn
      # onComplete: ->
      #   window.dispatchEvent exports.pageReadyEvent
    , '-=.8'

  setView: (exports, href) ->
    uriArray = href.split('/')
    view = uriArray[uriArray.length-1]
    if view is ''
      view = 'home'
    @view = exports.view = view
    @$main.attr 'data-view', view

  initFX: (exports) ->
    for controller in exports.controllers
      controller.init exports

App.Transition = Transition
