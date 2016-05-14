class TalkToUs
  constructor: ->
    @order = 12
    @initBuild = false

  build: (exports) ->
    exports.TalkToUsController = @
    exports.instances.push @

    @sleepWakeTL = undefined
    @blinkTL = undefined

    @init exports

  init: (exports) ->
    $character = $('.character-content')

    unless exports.isTouch
      $character.on 'mouseenter', (e) =>
        if exports.isAnimating
          return
        character = $(e.target).parents('.character').attr 'data-character'
        @wakeUp exports, character
      $character.on 'mouseleave', (e) =>
        @toSleep exports
    else
      @blinkTouch exports, 'ben'
      setTimeout =>
        @blinkTouch exports, 'tom'
      , 250

  wakeUp: (exports, character) ->
    @$defaultSprite = $(".character[data-character='#{character}'] .character-default")
    @$rolloverSprite = $(".character[data-character='#{character}'] .character-rollover")
    $copy = $(".character[data-character='#{character}'] .character-anim")

    @sleepWakeTL = new TimelineLite()
    .call @resetDefault, null, null, 0
    .set @$defaultSprite,
      opacity: 0
    .set @$rolloverSprite,
      backgroundPosition: '0 0'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-297px 0'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-594px 0'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-891px 0'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '0 -490px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-297px -490px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-594px -490px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-891px -490px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '0 -980px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-297px -980px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-594px -980px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-891px -980px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '0 -1470px'
      delay: .03
    .set @$rolloverSprite,
      backgroundPosition: '-297px -1470px'
      delay: .03
    .to $copy, .3,
      opacity: 1
      y: '0'
      onComplete: =>
        @blink exports, character
    , '-=.2'

  toSleep: (exports) ->
    if @blinkTL?
      @blinkTL.pause().kill()
      TweenLite.set @$rolloverSprite,
        opacity: 1
      TweenLite.set @$blinkSprite,
        opacity: 0
    @sleepWakeTL.timeScale(1.2).reverse()

  resetDefault: =>
    if @sleepWakeTL.reversed()
      TweenLite.set @$rolloverSprite,
        backgroundPosition: '0 0'
      TweenLite.set @$defaultSprite,
        opacity: 1
      TweenLite.set @$rolloverSprite,
        opacity: 1
      TweenLite.set @$blinkSprite,
        opacity: 0
      if @blinkTL?
        @blinkTL.pause().kill()

  blink: (exports, character) ->
    @$blinkSprite = $(".character[data-character='#{character}'] .character-blink")

    TweenLite.set @$rolloverSprite,
      opacity: 0
    TweenLite.set @$blinkSprite,
      opacity: 1

    @blinkTL = new TimelineLite()
    .set @$blinkSprite,
      opacity: 1
      delay: 1.5
    .set @$blinkSprite,
      backgroundPosition: '0 0'
    .set @$blinkSprite,
      backgroundPosition: '-297px 0'
      delay: .05
    .set @$blinkSprite,
      backgroundPosition: '-594px 0'
      delay: .05
    .set @$blinkSprite,
      backgroundPosition: '-891px 0'
      delay: .05
    .set @$blinkSprite,
      backgroundPosition: '0 -490px'
      delay: .05
    .set @$blinkSprite,
      backgroundPosition: '-297px -490px'
      delay: .05
    .set @$blinkSprite,
      backgroundPosition: '-594px -490px'
      delay: .05
    .set @$blinkSprite,
      backgroundPosition: '-891px -490px'
      delay: .05
    .set @$blinkSprite,
      backgroundPosition: '0 -980px'
      delay: .05
    .set @$blinkSprite,
      backgroundPosition: '-297px -980px'
      delay: .05
      onComplete: =>
        @blinkTL.restart()

  blinkTouch: (exports, character) ->
    $blinkSprite = $(".character[data-character='#{character}'] .character-blink")
    $rolloverSprite = $(".character[data-character='#{character}'] .character-rollover")
    $defaultSprite = $(".character[data-character='#{character}'] .character-default")

    TweenLite.set $defaultSprite,
      opacity: 0
    TweenLite.set $rolloverSprite,
      opacity: 0
    TweenLite.set $blinkSprite,
      opacity: 1

    blinkTL = new TimelineLite()
    .set $blinkSprite,
      opacity: 1
      delay: 1.5
    .set $blinkSprite,
      backgroundPosition: '0 0'
    .set $blinkSprite,
      backgroundPosition: '-297px 0'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-594px 0'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-891px 0'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '0 -490px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-297px -490px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-594px -490px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-891px -490px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '0 -980px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-297px -980px'
      delay: .05
      onComplete: ->
        blinkTL.restart()

  onResize: (exports) ->

App.Controllers.push new TalkToUs
