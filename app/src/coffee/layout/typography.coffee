class App.Typography
  constructor: ->
    @order = 1

  build: (exports) ->
    exports.TypographyController = @
    exports.controllers.push @

    @init exports

  init: (exports) ->
    @$repaintElement = $('.do-repaint')

  onResize: (exports) ->
    @$repaintElement.css 'z-index', 1

  onScroll: (exports, scrollY) ->

App.FXs.push new App.Typography
