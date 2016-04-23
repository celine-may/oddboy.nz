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
