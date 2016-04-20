class App.WhatWeDo
  constructor: ->
    @order = 10

  build: (exports) ->
    exports.WhatWeDoController = @
    exports.controllers.push @

    @showComplementTL = undefined

    @init exports

  init: (exports) ->
    @$complementPushElements = $('.do-complement-push')
    @$complement = $('.title-complement')

    @$showComplementBtn = $('.do-show-complement')

    unless exports.isTouch
      @$showComplementBtn.on 'mouseenter', @showComplement
      @$showComplementBtn.on 'mouseleave', @hideComplement
    else
      @$showComplementBtn.on 'click', (e) =>
        if @$complement.hasClass 'visible'
          @hideComplement()
          @$complement.removeClass 'visible'
        else
          @showComplement()
          @$complement.addClass 'visible'

  showComplement: =>
    @showComplementTL = new TimelineLite()
    .to @$complementPushElements, .2,
      y: 20
      ease: Power2.easeOut
    .to @$complement, .2,
      opacity: 1
      y: 0
      ease: Back.easeOut.config(1)
    , '-=.1'

  hideComplement: =>
    @showComplementTL.reverse()

  onResize: (exports) ->

  onScroll: (exports, scrollY) ->

App.FXs.push new App.WhatWeDo
