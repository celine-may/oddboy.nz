class WhatWeDo
  constructor: ->
    @order = 11
    @initBuild = false

  build: (exports) ->
    exports.WhatWeDoController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    @$complementPushElements = $('.do-complement-push')
    @$complement = $('.title-complement')

    @$showComplementBtn = $('.do-show-complement')
    @$setPaddingElement = $('.do-set-padding')

    @showComplementTL = new TimelineLite()

    unless exports.isTouch
      @$showComplementBtn.on 'mouseenter', =>
        if exports.isAnimating
          return
        @showComplement exports
      @$showComplementBtn.on 'mouseleave', @hideComplement
    else
      @$showComplementBtn.on 'click', (e) =>
        if @$complement.hasClass 'visible'
          @hideComplement()
          @$complement.removeClass 'visible'
        else
          @showComplement exports
          @$complement.addClass 'visible'

    @onResize exports

  showComplement: (exports) ->
    if exports.windowWidth <= exports.smallBreakpoint
      pushDelta = 60
    else if exports.smallBreakpoint < exports.windowWidth <= exports.mediumBreakpoint
      pushDelta = 40
    else
      pushDelta = 20
    @showComplementTL
    .to @$complementPushElements, .2,
      y: pushDelta
      ease: Power2.easeOut
    .to @$complement, .2,
      opacity: 1
      y: '+=35'
      ease: Back.easeOut.config(1)
    , '-=.1'

  hideComplement: =>
    @showComplementTL.reverse()

  onResize: (exports) ->
    unless @$setPaddingElement?
      return
    for element in @$setPaddingElement
      $element = $(element)
      if exports.windowWidth > exports.mediumBreakpoint
        elementPadding = 100
      else
        elementPadding = $element.parents('.service').find('.service-image').outerHeight() + 50
      $element.css 'padding-top', elementPadding

App.Controllers.push new WhatWeDo
