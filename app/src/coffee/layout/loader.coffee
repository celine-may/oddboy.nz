class App.Loader
  constructor: ->
    @order = 0

  build: (exports) ->
    exports.LoaderController = @
    exports.controllers.push @

    @init exports

  init: (exports) ->
    # DOM Elements
    @$window = $(window)
    @$wrapper = $('.loader-wrapper')
    @$path = $('.loader-path')
    @$device = $('.loader-device')
    @$letterBG = $('.loader-bg')
    @$letter = $('.loader-letter')
    @$mask = $('.loader-mask')
    @$circle = $('.loader-circle')
    @$panelLeft = $('.loader-panel.left')
    @$panelRight = $('.loader-panel.right')

    if exports.showLoader
      @playDevice exports
      @fillLoader exports
    else
      @$wrapper.remove()

  startLoader: (exports) ->
    @playDevice exports
    @fillLoader exports

  playDevice: (exports) ->
    deviceTL = new TimelineLite()
    .fromTo @$device, .6,
      y: exports.windowHeight * .25
    ,
      y: exports.windowHeight * .75
      delay: .3
      ease: Power2.easeInOut
    .to @$device, .6,
      y: exports.windowHeight * .25
      delay: .3
      ease: Power2.easeInOut
      onComplete: ->
        deviceTL.restart()

  fillLoader: (exports) ->
    loaderTL = new TimelineLite()
    .to @$letterBG, 4,
      width: 60
      delay: 1
      ease: Sine.easeOut
    .set @$letter,
      opacity: 1
    .set [ @$mask, @$letterBG ],
      opacity: 0
    .to @$letter, 1,
      rotationY: 180
      ease: Back.easeOut.config(2.7)
    .to @$circle, .6,
      y: exports.windowHeight
      ease: Power3.easeIn
    .to @$path, .2,
      opacity: 0
    , '-=.2'
    .to @$panelLeft, .5,
      xPercent: -100
    .to @$panelRight, .5,
      xPercent: 100
      onComplete: =>
        @$wrapper.remove()
    , '-=.5'

  onResize: (exports) ->

  onScroll: (exports, scrollY) ->

App.FXs.push new App.Loader
