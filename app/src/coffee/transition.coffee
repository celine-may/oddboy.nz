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
        duration: 800
        render: ($container) =>
          if @view is 'home'
            @leaveHome exports, @newView
          else
            @leaveView exports, @view
      onReady:
        duration: 600
        render: ($container, $newContent) =>
          $container.html $newContent
          currentView = @view
          @setView exports, smoothState.href

          if @newView is 'home'
            @showHome exports, currentView
          else
            @showView exports
      onAfter: ($container, $newContent) =>
        @initInstances @exports

    smoothState = @$main.smoothState(options).data 'smoothState'

    @initialTransition exports

  initialTransition: (exports) ->
    if @initiated
      return

    unless exports.skipLoader
      exports.LoaderController.playDevice exports
      exports.LoaderController.fillLoader exports
    else
      @showView exports

    @initiated = true

  leaveHome: (exports, newView) ->
    $panel = App.getPanel newView

    panelTL = new TimelineLite()
    .set $('.ui'),
      zIndex: 0
    .to $panel, .6,
      x: 0
      ease: Power3.easeIn

  leaveView: (exports, view) ->
    $panel = App.getPanel view
    $slideIn = $('.do-slide-in')
    $slideUp = $('.do-slide-up')

    direction = App.getDirection view

    leaveViewTL = new TimelineLite()
    .set $panel,
      x: 0
    .to $slideIn, .6,
      opacity: 0
      x: exports.windowWidth * .15 * direction
      ease: Power3.easeInOut
    .to $slideUp, .8,
      opacity: 0
      y: 20
      ease: Power3.easeIn
    , '-=.8'

  showHome: (exports, view) ->
    $panel = App.getPanel view
    $slideUp = $('.do-slide-up')
    direction = App.getDirection view

    panelTL = new TimelineLite()
    .fromTo $panel, .6,
      x: 0
    ,
      x: (exports.windowWidth - 15) * direction
      ease: Power3.easeIn
    .to $slideUp, .8,
      opacity: 1
      y: 0
      ease: Power3.easeIn

  showView: (exports) ->
    $slideIn = $('.do-slide-in')
    $slideUp = $('.do-slide-up')

    showViewTL = new TimelineLite()
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

  initInstances: (exports) ->
    for instance in exports.instances
      instance.init exports

App.Transition = Transition
