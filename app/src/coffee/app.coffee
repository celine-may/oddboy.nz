$ ->
  renderer = new App.Renderer
    fxs: App.FXs

  renderer.init()
  App.renderer = renderer

  for element in $('.do-replace-email')
    App.replaceEmail $(element)
