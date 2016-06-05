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
        @toSleep exports, e
    else
      @blinkTouch exports, 'ben'
      setTimeout =>
        @blinkTouch exports, 'tom'
      , 250

  wakeUp: (exports, character) ->
    @$sprite = $(".character[data-character='#{character}'] .character-sprite")
    @$copy = $(".character[data-character='#{character}'] .character-anim")

    @sleepWakeTL = new TimelineLite()
    .set @$sprite,
      backgroundPosition: '0 0'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-297px 0'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-594px 0'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-891px 0'
      delay: .03
    .set @$sprite,
      backgroundPosition: '0 -490px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-297px -490px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-594px -490px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-891px -490px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '0 -980px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-297px -980px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-594px -980px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-891px -980px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '0 -1470px'
      delay: .03
    .set @$sprite,
      backgroundPosition: '-297px -1470px'
      delay: .03
    .to @$copy, .3,
      opacity: 1
      y: '0'
      onComplete: =>
        @blink exports, character
    , '-=.2'

  toSleep: (exports, e) ->
    if @blinkTL?
      @blinkTL.pause().kill()
    if @sleepWakeTL?
      @sleepWakeTL.timeScale(1.2).reverse()
    setTimeout =>
      @$sprite.css 'background-position', '0 0'
    , 420

  blink: (exports, character) ->
    @blinkTL = new TimelineLite()
    .set @$sprite,
      opacity: 1
      delay: 1.5
    .set @$sprite,
      backgroundPosition: '-594px -980px'
    .set @$sprite,
      backgroundPosition: '-891px -980px'
      delay: .05
    .set @$sprite,
      backgroundPosition: '0 -1470px'
      delay: .05
    .set @$sprite,
      backgroundPosition: '-297px -1470px'
      delay: .05
    .set @$sprite,
      backgroundPosition: '-594px -1470px'
      delay: .05
    .set @$sprite,
      backgroundPosition: '-891px -1470px'
      delay: .05
    .set @$sprite,
      backgroundPosition: '0 -1960px'
      delay: .05
    .set @$sprite,
      backgroundPosition: '-297px -1960px'
      delay: .05
    .set @$sprite,
      backgroundPosition: '-594px -1960px'
      delay: .05
    .set @$sprite,
      backgroundPosition: '-891px -1960px'
      delay: .05
      onComplete: =>
        @blinkTL.restart()

  blinkTouch: (exports, character) ->
    $blinkSprite = $(".character[data-character='#{character}'] .character-sprite")

    TweenLite.set $blinkSprite,
      opacity: 1

    blinkTL = new TimelineLite()
    .set $blinkSprite,
      opacity: 1
      delay: 1.5
    .set $blinkSprite,
      backgroundPosition: '-594px -980px'
    .set $blinkSprite,
      backgroundPosition: '-891px -980px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '0 -1470px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-297px -1470px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-594px -1470px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-891px -1470px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '0 -1960px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-297px -1960px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-594px -1960px'
      delay: .05
    .set $blinkSprite,
      backgroundPosition: '-891px -1960px'
      delay: .05
      onComplete: ->
        blinkTL.restart()

  onResize: (exports) ->

App.Controllers.push new TalkToUs
