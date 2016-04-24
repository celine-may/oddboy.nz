getPanel = (view) ->
  if view is 'what-we-do'
    $('.panel.lhs')
  else
    $('.panel.rhs')
App.getPanel = getPanel

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
