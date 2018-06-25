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

    @preventScroll = false
    @initBreakpoint = exports.currentBreakpoint
    @delta = 150

    if exports.view is 'home'
      @$view = $('.view[data-view="home"]')
      @initHome exports
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

  initHome: (exports) ->
    if exports.isTouch
      @preventScroll = true
      return

    @$header = @$view.find '.header'

    @homeHeaderTL = undefined

    TweenLite.set @$header,
      y: 0

    @initHomeTL exports

  initHomeTL: (exports) ->
    $scrollCTA = @$header.find('.scroll-cta-wrapper')

    @homeHeaderTL = new TimelineLite
      paused: true
    .to $scrollCTA, 1,
      y: exports.windowHeight / -5
      opacity: 0
      ease: Power2.easeOut

  initWWD: (exports) ->
    if exports.isTouch
      @preventScroll = true
      return

    @$header = @$view.find '.header'
    @$gameDesign = @$view.find '.service[data-service="game-design"]'
    @$virtualReality = @$view.find '.service[data-service="virtual-reality"]'
    @$digitalProducts = @$view.find '.service[data-service="digital-products"]'

    @$gameDesignYElements = @$gameDesign.find '.do-anim-y'
    @$gameDesignMElements = @$gameDesign.find '.do-anim-m'
    @$virtualRealityYElements = @$virtualReality.find '.do-anim-y'
    @$virtualRealityMElements = @$virtualReality.find '.do-anim-m'
    @$digitalProductsYElements = @$digitalProducts.find '.do-anim-y'
    @$digitalProductsMElements = @$digitalProducts.find '.do-anim-m'

    @gameDesignStart = @$gameDesign.offset().top - exports.windowHeight
    @gameDesignStop = @gameDesignStart + exports.windowHeight + @delta
    @virtualRealityStart = @$virtualReality.offset().top - exports.windowHeight
    @virtualRealityStop = @virtualRealityStart + exports.windowHeight + @delta
    @digitalProductsStart = @$digitalProducts.offset().top - exports.windowHeight
    @digitalProductsStop = @digitalProductsStart + exports.windowHeight + @delta

    @wwdHeaderTL = undefined
    @gameDesignTL = undefined
    @virtualRealityTL = undefined

    TweenLite.set [@$header, @$header.find('.header-content')],
      y: 0

    @initWWDTL exports

  initWWDTL: (exports) ->
    @wwdHeaderTL = new TimelineLite
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

  initTTU: (exports) ->
    if exports.isTouch || exports.isSmall || exports.isMedium
      @preventScroll = true
      return

    @$header = @$view.find '.header'

    @ttuHeaderTL = undefined

    TweenLite.set [@$header, @$header.find('.header-content'), @$header.find('.scroll-cta')],
      y: 0

    @initTTUTL exports

  initTTUTL: (exports) ->
    @ttuHeaderTL = new TimelineLite
      paused: true
    .to @$header.find('.header-content, .scroll-cta'), 1,
      y: exports.windowHeight / -3
      opacity: 0
      ease: Power2.easeOut

  scrollDown: (exports) ->
    TweenLite.to @$view, 1,
      scrollTo:
        y: exports.windowHeight
        ease: Power2.easeOut

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
    if @preventScroll
      return

    scrollY = @$view.scrollTop()

    @$header.css
      transform: "translateY(#{scrollY}px)"

    # What we do Timelines
    @scrollTween exports, 0, exports.windowHeight * 1.3, @wwdHeaderTL, scrollY
    @scrollTween exports, @gameDesignStart, @gameDesignStop, @gameDesignTL, scrollY
    @scrollTween exports, @virtualRealityStart, @virtualRealityStop, @virtualRealityTL, scrollY
    @scrollTween exports, @digitalProductsStart, @digitalProductsStop, @digitalProductsTL, scrollY

    # Talk to us Timelines
    @scrollTween exports, 0, exports.windowHeight, @ttuHeaderTL, scrollY

    # Home Timeline
    @scrollTween exports, 0, exports.windowHeight, @homeHeaderTL, scrollY

  onResize: (exports) ->
    if @initBreakpoint != exports.currentBreakpoint
      @init exports

App.Controllers.push new Scroll
