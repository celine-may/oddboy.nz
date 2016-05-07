class Typography
  constructor: ->
    @order = 2

  build: (exports) ->
    exports.TypographyController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    @$repaintElement = $('.do-repaint')

  onResize: (exports) ->
    @$repaintElement.css 'z-index', 1

  onScroll: (exports, scrollY) ->

App.Controllers.push new Typography
