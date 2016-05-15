class Scroll
  constructor: ->
    @order = 3
    @initBuild = false

  build: (exports) ->
    exports.ScrollController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    @$scrollDownBtn = $('.do-scroll-down')

    @delta = 150

    if exports.view is 'home'
      return
    else if exports.view is 'what-we-do'
      @$view = $('.view[data-view="what-we-do"]')
      @initWWD exports
    else if exports.view is 'talk-to-us'
      @$view = $('.view[data-view="talk-to-us"]')
      @initTTU exports

    @$view.on 'scroll', =>
      @onScroll exports

    @$scrollDownBtn.on 'click', =>
      @scrollDown exports

  initWWD: (exports) ->
    @$header = @$view.find '.header'
    @$gameDesign = @$view.find '.service[data-service="game-design"]'
    @$virtualReality = @$view.find '.service[data-service="virtual-reality"]'
    @$digitalProducts = @$view.find '.service[data-service="digital-products"]'
    @$work = @$view.find '.work-wrapper'

    @$gameDesignYElements = @$gameDesign.find '.do-anim-y'
    @$gameDesignMElements = @$gameDesign.find '.do-anim-m'
    @$virtualRealityYElements = @$virtualReality.find '.do-anim-y'
    @$virtualRealityMElements = @$virtualReality.find '.do-anim-m'
    @$digitalProductsYElements = @$digitalProducts.find '.do-anim-y'
    @$digitalProductsMElements = @$digitalProducts.find '.do-anim-m'
    @$workElements = @$work.find '.do-anim-y'

    @gameDesignStart = @$gameDesign.offset().top - exports.windowHeight
    @gameDesignStop = @gameDesignStart + exports.windowHeight + @delta
    @virtualRealityStart = @$virtualReality.offset().top - exports.windowHeight
    @virtualRealityStop = @virtualRealityStart + exports.windowHeight + @delta
    @digitalProductsStart = @$digitalProducts.offset().top - exports.windowHeight
    @digitalProductsStop = @digitalProductsStart + exports.windowHeight + @delta
    @workStart = @$work.offset().top - exports.windowHeight + 700
    @workStop = @workStart + @$work.outerHeight() + 260 + @delta

    @headerTL = undefined
    @gameDesignTL = undefined
    @virtualRealityTL = undefined
    @workTL = undefined

    TweenLite.set [@$header, @$header.find('.header-content')],
      y: 0

    @initWWDTL exports

  initTTU: (exports) ->
    @$header = @$view.find '.header'

    @$contactElements = @$view.find '.do-anim-y'

    @contactStart = exports.windowHeight * 3/4
    @contactStop = exports.windowHeight

    @contactTL = undefined

    @initTTUTL exports

  initWWDTL: (exports) ->
    @headerTL = new TimelineLite
      paused: true
    .to @$header.find('.header-content'), 1,
      y: exports.windowHeight / -2.7
      opacity: 0
      ease: Power2.easeOut

    @gameDesignTL = new TimelineMax
      paused: true
    .to @$gameDesignYElements, 1,
      y: 0
      ease: Power2.easeOut
    .to @$gameDesignMElements, 1,
      marginTop: 0
      ease: Power2.easeOut
    , '-=1'

    @virtualRealityTL = new TimelineMax
      paused: true
    .to @$virtualRealityYElements, 1,
      y: 0
      ease: Power2.easeOut
    .to @$virtualRealityMElements, 1,
      marginTop: 0
      ease: Power2.easeOut
    , '-=1'

    @digitalProductsTL = new TimelineMax
      paused: true
    .to @$digitalProductsYElements, 1,
      y: 0
      ease: Power2.easeOut
    .to @$digitalProductsMElements, 1,
      marginTop: 0
      ease: Power2.easeOut
    , '-=1'

    @workTL = new TimelineMax
      paused: true
    .to @$workElements, 1,
      y: 0
      ease: Power2.easeOut

  initTTUTL: (exports) ->
    @headerTL = new TimelineLite
      paused: true
    .to @$header.find('.header-content'), 1,
      y: exports.windowHeight / -3
      ease: Power2.easeOut
    @contactTL = new TimelineMax
      paused: true
    .to @$contactElements, 1,
      y: 0
      ease: Power2.easeOut

  scrollDown: (exports) ->
    TweenLite.to @$view, 1,
      scrollTo:
        y: exports.windowHeight
        ease: Power2.easeOut

  onResize: (exports) ->

  scrollTween: (exports, startPoint, endPoint, tweenName, scrollY) ->
    unless tweenName?
      return
    progressValue = (1 / (endPoint - startPoint)) * (scrollY - startPoint)
    if 0 <= progressValue <= 1
      tweenName.progress progressValue
      exports.currentProgressValue = progressValue
    else if progressValue < 0
      tweenName.progress 0
    else if progressValue > 1
      tweenName.progress 1

  onScroll: (exports) ->
    scrollY = @$view.scrollTop()

    @$header.css
      transform: "translateY(#{scrollY}px)"

    # What we do Timelines
    @scrollTween exports, 0, exports.windowHeight * 1.3, @headerTL, scrollY
    @scrollTween exports, @gameDesignStart, @gameDesignStop, @gameDesignTL, scrollY
    @scrollTween exports, @virtualRealityStart, @virtualRealityStop, @virtualRealityTL, scrollY
    @scrollTween exports, @digitalProductsStart, @digitalProductsStop, @digitalProductsTL, scrollY
    @scrollTween exports, @workStart, @workStop, @workTL, scrollY

    # Talk to us Timelines
    @scrollTween exports, 0, exports.windowHeight, @headerTL, scrollY
    @scrollTween exports, @contactStart, @contactStop, @contactTL, scrollY

App.Controllers.push new Scroll
