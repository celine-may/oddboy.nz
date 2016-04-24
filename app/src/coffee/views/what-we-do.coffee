class App.WhatWeDo
  constructor: ->
    @order = 10

  build: (exports) ->
    exports.WhatWeDoController = @
    exports.controllers.push @

    @showComplementTL = undefined
    @workDetailsTL = undefined

    @init exports

  init: (exports) ->
    @$complementPushElements = $('.do-complement-push')
    @$complement = $('.title-complement')

    @$showComplementBtn = $('.do-show-complement')
    @$showWorkDetailsElement = $('.do-show-work-details')

    unless exports.isTouch
      @$showComplementBtn.on 'mouseenter', @showComplement
      @$showComplementBtn.on 'mouseleave', @hideComplement
      @$showWorkDetailsElement.on 'mouseenter', @showWorkDetails
      @$showWorkDetailsElement.on 'mouseleave', =>
        @hideWorkDetails()
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

  showWorkDetails: (e) =>
    $element = $(e.target).parents '.work'
    $details = $element.find '.work-anim'

    @workDetailsTL = new TimelineLite()
    .to $element, .3,
      height: 410
      ease: Power2.easeOut
    .to $element.find('.work-title'), .5,
      y: 30
      ease: Back.easeOut.config(.5)
    , '-=.4'
    .to $details, .5,
      opacity: 1
      y: 30
      ease: Back.easeOut.config(.5)
    , '-=.5'

  hideWorkDetails: =>
    @workDetailsTL.reverse()

  onResize: (exports) ->

  onScroll: (exports, scrollY) ->

App.FXs.push new App.WhatWeDo
