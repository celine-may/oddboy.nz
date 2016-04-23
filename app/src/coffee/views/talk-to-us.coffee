class App.TalkToUs
  constructor: ->
    @order = 11

  build: (exports) ->
    exports.TalkToUsController = @
    exports.controllers.push @

    @sleepWakeTL = undefined
    @blinkTL = undefined

    @init exports

  init: (exports) ->
    $character = $('.character-content')

    $character.on 'mouseenter', (e) =>
      character = $(e.target).parents('.character').attr 'data-character'
      @wakeUp exports, character
    $character.on 'mouseleave', (e) =>
      @toSleep exports

  wakeUp: (exports, character) ->
    @$default = $(".character[data-character='#{character}'] .character-default")
    @$rolloverSprite = $(".character[data-character='#{character}'] .character-rollover")

    @sleepWakeTL = new TimelineLite()
    .set @$default,
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
      onComplete: =>
        @blink exports, character

  toSleep: (exports) ->
    if @blinkTL?
      @blinkTL.pause().kill()
      @$rolloverSprite.css 'opacity', 1
      @$blinkSprite.css 'opacity', 0
    @sleepWakeTL.timeScale(1.2).reverse()
    setTimeout =>
      @$default.css 'opacity', 1
    , 500

  blink: (exports, character) ->
    @$blinkSprite = $(".character[data-character='#{character}'] .character-blink")

    @blinkTL = new TimelineLite()
    .set @$rolloverSprite,
      opacity: 0
      delay: 1.5
    .set @$blinkSprite,
      opacity: 1
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

  onResize: (exports) ->

  onScroll: (exports, scrollY) ->

App.FXs.push new App.TalkToUs
