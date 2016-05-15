class Loader
  constructor: ->
    @order = 1
    @initBuild = true

  build: (exports) ->
    exports.LoaderController = @
    exports.instances.push @

    @manifest = [
      id: 'benRolloverSprite'
      itemType: 'bg'
      element: '.character[data-character="ben"] .character-rollover'
      src: "#{exports.path}assets/images/characters/ben-rollover-sprite.png"
    ,
      id: 'benBlinkSprite'
      itemType: 'bg'
      element: '.character[data-character="ben"] .character-blink'
      src: "#{exports.path}assets/images/characters/ben-blink-sprite.png"
    ,
      id: 'tomRolloverSprite'
      itemType: 'bg'
      element: '.character[data-character="tom"] .character-rollover'
      src: "#{exports.path}assets/images/characters/tom-rollover-sprite.png"
    ,
      id: 'tomBlinkSprite'
      itemType: 'bg'
      element: '.character[data-character="tom"] .character-blink'
      src: "#{exports.path}assets/images/characters/tom-blink-sprite.png"
    ,
      id: 'spriteShadow'
      itemType: 'bg'
      element: '.character-content'
      src: "#{exports.path}assets/images/characters/shadow.png"
    ,
      id: 'digitalProducts'
      itemType: 'img'
      element: '.service[data-service="digital-products"] .service-image'
      src: "#{exports.path}assets/images/services/digital-products.png"
    ,
      id: 'gameDesign'
      itemType: 'img'
      element: '.service[data-service="game-design"] .service-image'
      src: "#{exports.path}assets/images/services/game-design.jpg"
    ,
      id: 'virtualReality'
      itemType: 'img'
      element: '.service[data-service="virtual-reality"] .service-image'
      src: "#{exports.path}assets/images/services/virtual-reality.png"
    ,
      id: 'barkle'
      itemType: 'bg'
      element: '.work-bg[data-work="barkle"]'
      src: "#{exports.path}assets/images/work/barkle.jpg"
    ,
      id: 'campHopeFalls'
      itemType: 'bg'
      element: '.work-bg[data-work="camp-hope-falls"]'
      src: "#{exports.path}assets/images/work/camp-hope-falls.jpg"
    ,
      id: 'celine'
      itemType: 'bg'
      element: '.work-bg[data-work="celine"]'
      src: "#{exports.path}assets/images/work/celine.jpg"
    ,
      id: 'yankyDoodle'
      itemType: 'bg'
      element: '.work-bg[data-work="yanky-doodle"]'
      src: "#{exports.path}assets/images/work/yanky-doodle.jpg"
    ,
      id: 'oddboyCopy'
      itemType: 'object'
      src: "#{exports.path}assets/json/oddboy-copy.json"
    ,
      id: 'oddboyLogo'
      itemType: 'object'
      src: "#{exports.path}assets/json/oddboy-logo.json"
    ,
      id: 'svgDefs'
      itemType: 'svg'
      element: 'body'
      src: "#{exports.path}assets/svgs/svg-defs.svg"
    ]

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

    @queue = undefined
    @startTime = undefined
    @duration = 1

    @loadAssets exports

  loadAssets: (exports) ->
    @queue = new createjs.LoadQueue()

    @queue.on 'loadstart', (e) =>
      @onLoadStart e, exports
    @queue.on 'fileload', (e) =>
      @onFileLoad e, exports
    @queue.on 'complete', (e) =>
      @onLoadComplete e, exports
    @queue.on 'error', (e) =>
      @onLoadError e, exports

    @queue.loadManifest @manifest

  onLoadStart: (e, exports) ->
    @startTime = Date.now()
    @deviceAnimation exports
    @letterAnimation exports

  onFileLoad: (e, exports) ->
    if e.item.itemType is 'bg'
      $(e.item.element).css 'background-image', "url(#{e.item.src})"
    else if e.item.itemType is 'img'
      $(e.item.element).append $(e.result).addClass 'y-push2 do-anim-y'
    else if e.item.itemType is 'svg'
      $(e.item.element).prepend $(e.result).hide()

  onLoadComplete: (e, exports) ->
    endTime = Date.now()
    currentDuration = endTime - @startTime
    delta = @duration * 1000 - currentDuration
    exports.RendererController.delayedBuild exports
    setTimeout =>
      if exports.view is 'home'
        App.startMainLoop()
      @loaderAnimation exports
    , delta

  onLoadError: (e, exports) ->
    console.log 'onError'

  deviceAnimation: (exports) ->
    deviceTL = new TimelineMax
      paused: true
    .fromTo @$device, 1.2,
      y: exports.windowHeight * .15
    ,
      y: exports.windowHeight * .85
      ease: Expo.easeInOut

    deviceTL.yoyo(true).repeat(-1).play()

  letterAnimation: (exports) ->
    TweenLite.to @$letterBG, @duration,
      width: 60
      ease: Sine.easeOut

  loaderAnimation: (exports) ->
    loaderTL = new TimelineLite()
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
    .call ->
      exports.WebglController.animateIn exports
    , null, null, 1.6


  onResize: (exports) ->

App.Controllers.push new Loader
