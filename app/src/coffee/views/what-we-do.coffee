class WhatWeDo
  constructor: ->
    @order = 11
    @initBuild = false

  build: (exports) ->
    exports.WhatWeDoController = @
    exports.instances.push @

    @showComplementTL = undefined
    @workDetailsTL = undefined

    @init exports

  init: (exports) ->
    @$complementPushElements = $('.do-complement-push')
    @$complement = $('.title-complement')

    @$showComplementBtn = $('.do-show-complement')
    @$showWorkDetailsElement = $('.do-show-work-details')
    @$setPaddingElement = $('.do-set-padding')

    unless exports.isTouch
      @$showComplementBtn.on 'mouseenter', =>
        if exports.isAnimating
          return
        @showComplement exports
      @$showComplementBtn.on 'mouseleave', @hideComplement

      @$showWorkDetailsElement.on 'mouseenter', (e) =>
        if exports.isAnimating
          return
        @showWorkDetails e
      @$showWorkDetailsElement.on 'mouseleave', @hideWorkDetails
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
    @showComplementTL = new TimelineLite()
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

  showWorkDetails: (e) =>
    $element = $(e.target).parents '.work'
    $details = $element.find '.work-anim'

    @workDetailsTL = new TimelineLite()
    .to $element, .4,
      height: 410
      ease: Power2.easeInOut
    .to $element.find('.work-title'), .5,
      y: 30
      ease: Power2.easeInOut
    , '-=.4'
    .to $details, .5,
      opacity: 1
      y: 30
      ease: Power2.easeInOut
    , '-=.5'

  hideWorkDetails: =>
    @workDetailsTL.reverse()

  onResize: (exports) ->
    unless @$setPaddingElement?
      return
    for element in @$setPaddingElement
      $element = $(element)
      if exports.windowWidth > exports.mediumBreakpoint
        elementPadding = 160
      else
        elementPadding = $element.parents('.service').find('.service-image').outerHeight() + 50
      $element.css 'padding-top', elementPadding

App.Controllers.push new WhatWeDo
