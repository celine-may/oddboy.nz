π = App.π = Math.PI

toRGB = (hexColor) ->
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec hexColor
  rgb = {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  }
App.toRGB = toRGB

getOppositeView = (view) ->
  if view is 'what-we-do'
    'talk-to-us'
  else
    'what-we-do'
App.getOppositeView = getOppositeView

getDirection = (view) ->
  if view is 'what-we-do'
    -1
  else
    1
App.getDirection = getDirection

replaceEmail = ($element) ->
  className = $element.attr 'data-class'
  value = $element
    .html()
    .replace(/\[dot\]/g, '.')
    .replace('[at]', '@')

  $newElement = $('<a>')
    .attr 'href', "mailto:#{value}"
    .html value
    .addClass className
  $element.replaceWith $newElement
App.replaceEmail = replaceEmail
