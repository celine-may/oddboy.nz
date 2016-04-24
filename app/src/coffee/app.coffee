$ ->

  # OS detection
  unless navigator.appVersion.indexOf('Mac') is -1
    $('html').addClass 'is-mac'

  renderer = new App.Renderer
    fxs: App.FXs

  renderer.init()
  App.renderer = renderer

  # Email replacement
  for element in $('.do-replace-email')
    App.replaceEmail $(element)
