class Loader
  constructor: ->
    @order = 1
    @initBuild = true

  build: (exports) ->
    exports.LoaderController = @
    exports.instances.push @

    commonManifest = [
      id: 'talkToUs'
      itemType: 'bg'
      element: '.contact-wrapper'
      src: "#{exports.cdnPath}assets/images/talk-to-us/computer-holla.gif"
    ,
      id: 'spriteShadow'
      itemType: 'bg'
      element: '.character-content'
      src: "#{exports.cdnPath}assets/images/characters/shadow.png"
    ,
      id: 'whatWeDo'
      itemType: 'bg'
      element: '.view[data-view="what-we-do"] .header'
      src: "#{exports.cdnPath}assets/images/what-we-do/bg.jpg"
    ,
      id: 'digitalProducts'
      itemType: 'img'
      element: '.service[data-service="digital-products"] .service-image'
      src: "#{exports.cdnPath}assets/images/services/digital-products.png"
    ,
      id: 'gameDesign'
      itemType: 'img'
      element: '.service[data-service="game-design"] .service-image'
      src: "#{exports.cdnPath}assets/images/services/game-design.png"
    ,
      id: 'virtualReality'
      itemType: 'img'
      element: '.service[data-service="virtual-reality"] .service-image'
      src: "#{exports.cdnPath}assets/images/services/virtual-reality.png"
    ,
      id: 'jrump'
      itemType: 'bg'
      element: '.project-card[data-project="jrump"]'
      src: "#{exports.cdnPath}assets/images/projects/jrump.jpg"
    ,
      id: 'wanderer'
      itemType: 'bg'
      element: '.project-card[data-project="wanderer"]'
      src: "#{exports.cdnPath}assets/images/projects/wanderer.jpg"
    ,
      id: 'catty-crush'
      itemType: 'bg'
      element: '.project-card[data-project="catty-crush"]'
      src: "#{exports.cdnPath}assets/images/projects/catty-crush.jpg"
    ,
      id: 'kabashians'
      itemType: 'bg'
      element: '.project-card[data-project="kabashians"]'
      src: "#{exports.cdnPath}assets/images/projects/kabashians.jpg"
    ,
      id: 'camp-hope-falls'
      itemType: 'bg'
      element: '.project-card[data-project="camp-hope-falls"]'
      src: "#{exports.cdnPath}assets/images/projects/camp-hope-falls.jpg"
    ,
      id: 'ar-book'
      itemType: 'bg'
      element: '.project-card[data-project="ar-book"]'
      src: "#{exports.cdnPath}assets/images/projects/ar-book.jpg"
    ,
      id: 'orpheus-ar'
      itemType: 'bg'
      element: '.project-card[data-project="orpheus-ar"]'
      src: "#{exports.cdnPath}assets/images/projects/orpheus-ar.jpg"
    ,
      id: 'rubberkid'
      itemType: 'bg'
      element: '.project-card[data-project="rubberkid"]'
      src: "#{exports.cdnPath}assets/images/projects/rubberkid.jpg"
    ,
      id: 'meili'
      itemType: 'bg'
      element: '.project-card[data-project="meili"]'
      src: "#{exports.cdnPath}assets/images/projects/meili.jpg"
    ,
      id: 'dan-murphys-ar'
      itemType: 'bg'
      element: '.project-card[data-project="dan-murphys-ar"]'
      src: "#{exports.cdnPath}assets/images/projects/dan-murphys-ar.jpg"
    ,
      id: 'tradee'
      itemType: 'bg'
      element: '.project-card[data-project="tradee"]'
      src: "#{exports.cdnPath}assets/images/projects/tradee.jpg"
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

    desktopManifest = [
      id: 'benSpriteHD'
      itemType: 'bg'
      element: '.character[data-character="ben"] .character-sprite'
      src: "#{exports.cdnPath}assets/images/characters/ben-sprite-ld.png"
    ,
      id: 'tomSpriteHD'
      itemType: 'bg'
      element: '.character[data-character="tom"] .character-sprite'
      src: "#{exports.cdnPath}assets/images/characters/tom-sprite-ld.png"
    ]

    touchManifest = [
      id: 'benBlinkSprite'
      itemType: 'bg'
      element: '.character[data-character="ben"] .character-sprite'
      src: "#{exports.cdnPath}assets/images/characters/ben-blink-sprite.png"
    ,
      id: 'tomBlinkSprite'
      itemType: 'bg'
      element: '.character[data-character="tom"] .character-sprite'
      src: "#{exports.cdnPath}assets/images/characters/tom-blink-sprite.png"
    ]

    mobileManifest = [
      id: 'benSpriteLD'
      itemType: 'bg'
      element: '.character[data-character="ben"] .character-sprite'
      src: "#{exports.cdnPath}assets/images/characters/ben-sprite-ld.png"
    ,
      id: 'tomSpriteLD'
      itemType: 'bg'
      element: '.character[data-character="tom"] .character-sprite'
      src: "#{exports.cdnPath}assets/images/characters/tom-sprite-ld.png"
    ]

    if exports.isTouch
      @manifest = commonManifest.concat touchManifest
    else if exports.windowWidth <= exports.mediumBreakpoint and not exports.touch
      @manifest = commonManifest.concat mobileManifest
    else
      @manifest = commonManifest.concat desktopManifest

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
    @duration = 4

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
    console.log e

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
