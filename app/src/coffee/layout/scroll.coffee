class Scroll
  constructor: ->
    @order = 3
    @initBuild = false

  build: (exports) ->
    exports.ScrollController = @
    exports.instances.push @

    @headerTL = undefined
    @gameDesignTL = undefined
    @virtualRealityTL = undefined
    @workTL = undefined

    @delta = 150

    @init exports

  init: (exports) ->
    @$view = $('.view.lhs')
    @$header = @$view.find '.header'
    @$gameDesign = @$view.find '.service[data-service="game-design"]'
    @$virtualReality = @$view.find '.service[data-service="virtual-reality"]'
    @$digitalProducts = @$view.find '.service[data-service="digital-products"]'
    @$work = @$view.find '.work-wrapper'

    @$gameDesignElements = @$gameDesign.find '.do-anim-scroll'
    @$virtualRealityElements = @$virtualReality.find '.do-anim-scroll'
    @$digitalProductsElements = @$digitalProducts.find '.do-anim-scroll'
    @$workElements = @$work.find '.do-anim-scroll'

    @gameDesignStart = @$gameDesign.offset().top - exports.windowHeight
    @gameDesignStop = @gameDesignStart + exports.windowHeight + @delta
    @virtualRealityStart = @$virtualReality.offset().top - exports.windowHeight
    @virtualRealityStop = @virtualRealityStart + exports.windowHeight + @delta
    @digitalProductsStart = @$digitalProducts.offset().top - exports.windowHeight
    @digitalProductsStop = @digitalProductsStart + exports.windowHeight + @delta
    @workStart = @$work.offset().top - exports.windowHeight + 700
    @workStop = @workStart + @$work.outerHeight() + 260 + @delta

    @initTL exports

    @$view.on 'scroll', =>
      @onScroll exports

  initTL: (exports) ->
    @headerTL = new TimelineLite
      paused: true
    .to @$header.find('.header-content'), 1,
      y: exports.windowHeight / -3
      ease: Power2.easeOut
    @gameDesignTL = new TimelineMax
      paused: true
    .to @$gameDesignElements, 1,
      y: 0
      ease: Power2.easeOut
    @virtualRealityTL = new TimelineMax
      paused: true
    .to @$virtualRealityElements, 1,
      y: 0
      ease: Power2.easeOut
    @digitalProductsTL = new TimelineMax
      paused: true
    .to @$digitalProductsElements, 1,
      y: 0
      ease: Power2.easeOut
    @workTL = new TimelineMax
      paused: true
    .to @$workElements, 1,
      y: 0
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

    unless exports.isTouch
      @scrollTween exports, 0, exports.windowHeight * 1.3, @headerTL, scrollY
      @scrollTween exports, @gameDesignStart, @gameDesignStop, @gameDesignTL, scrollY
      @scrollTween exports, @virtualRealityStart, @virtualRealityStop, @virtualRealityTL, scrollY
      @scrollTween exports, @digitalProductsStart, @digitalProductsStop, @digitalProductsTL, scrollY
      @scrollTween exports, @workStart, @workStop, @workTL, scrollY

App.Controllers.push new Scroll
