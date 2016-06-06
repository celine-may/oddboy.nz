class TalkToUs
  constructor: ->
    @order = 12
    @initBuild = false

  build: (exports) ->
    exports.TalkToUsController = @
    exports.instances.push @

    @benTL = undefined
    @tomTL = undefined

    @sleepWakeTL = undefined
    @blinkTL = undefined

    @init exports

  init: (exports) ->
    $character = $('.character-content')

    unless exports.isTouch
      @initBenTL exports
      @initTomTL exports

      $character.on 'mouseenter', (e) =>
        if exports.isAnimating
          return
        character = $(e.target).parents('.character').attr 'data-character'
        $copy = $(".character[data-character='#{character}'] .character-anim")
        TweenLite.to $copy, .3,
          opacity: 1
          y: '0%'
        if character is 'ben'
          @benTL.timeScale(1).play()
        else
          @tomTL.timeScale(1).play()

      $character.on 'mouseleave', (e) =>
        character = $(e.target).parents('.character').attr 'data-character'
        $copy = $(".character[data-character='#{character}'] .character-anim")
        TweenLite.to $copy, .3,
          opacity: 0
          y: '-100%'
        if character is 'ben'
          @benTL.timeScale(3).reverse()
        else
          @tomTL.timeScale(3).reverse()
    else
      @blinkTouch exports, 'ben'
      setTimeout =>
        @blinkTouch exports, 'tom'
      , 250

  initBenTL: (exports) ->
    $benSprite = $('.character[data-character="ben"] .character-sprite')
    @benTL = new TimelineLite
      paused: true
    .set $benSprite,
      backgroundPosition: '0 0'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-297px 0'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-594px 0'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-891px 0'
      delay: .03
    .set $benSprite,
      backgroundPosition: '0 -490px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-297px -490px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-594px -490px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-891px -490px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '0 -980px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-297px -980px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-594px -980px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-891px -980px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '0 -1470px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-297px -1470px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-594px -980px'
      delay: 1.5
    .set $benSprite,
      backgroundPosition: '-891px -980px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '0 -1470px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-297px -1470px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-594px -1470px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-891px -1470px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '0 -1960px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-297px -1960px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-594px -1960px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-891px -1960px'
      delay: .05
      onComplete: =>
        @benTL.time(0.42)

  initTomTL: (exports) ->
    $benSprite = $('.character[data-character="tom"] .character-sprite')
    @tomTL = new TimelineLite
      paused: true
    .set $benSprite,
      backgroundPosition: '0 0'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-297px 0'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-594px 0'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-891px 0'
      delay: .03
    .set $benSprite,
      backgroundPosition: '0 -490px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-297px -490px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-594px -490px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-891px -490px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '0 -980px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-297px -980px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-594px -980px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-891px -980px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '0 -1470px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-297px -1470px'
      delay: .03
    .set $benSprite,
      backgroundPosition: '-594px -980px'
      delay: 1.5
    .set $benSprite,
      backgroundPosition: '-891px -980px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '0 -1470px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-297px -1470px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-594px -1470px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-891px -1470px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '0 -1960px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-297px -1960px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-594px -1960px'
      delay: .05
    .set $benSprite,
      backgroundPosition: '-891px -1960px'
      delay: .05
      onComplete: =>
        @tomTL.time(0.42)

  blinkTouch: (exports, character) ->
    $blinkSprite = $(".character[data-character='#{character}'] .character-sprite")

    blinkTL = new TimelineLite()
    .set $blinkSprite,
      backgroundPosition: '0 0'
      delay: 1.5
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
