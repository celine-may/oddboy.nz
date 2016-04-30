class App.Typography
  constructor: ->
    @order = 3

  build: (exports) ->
    exports.TypographyController = @
    exports.instances.push @

    @init exports

  init: (exports) ->
    @$repaintElement = $('.do-repaint')

  onUpdate: ->

  onResize: (exports) ->
    @$repaintElement.css 'z-index', 1

  onScroll: (exports, scrollY) ->

App.Controllers.push new App.Typography
