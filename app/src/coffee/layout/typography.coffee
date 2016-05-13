class Typography
  constructor: ->
    @order = 2
    @initBuild = false
    @initiated = false

  build: (exports) ->
    exports.TypographyController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    @initiated = true
    @$repaintElement = $('.do-repaint')

  onResize: (exports) ->
    unless @initiated
      return
    @$repaintElement.css 'z-index', 1

App.Controllers.push new Typography
