jQuery.fn.sortElements = (->
  sort = [].sort
  (comparator, getSortable) ->
    getSortable = getSortable or ->
      this

    placements = @map(->
      sortElement = getSortable.call(this)
      parentNode = sortElement.parentNode
      nextSibling = parentNode.insertBefore(document.createTextNode(""), sortElement.nextSibling)
      ->
        throw new Error("You can't sort elements if any one is a descendant of another.")  if parentNode is this
        parentNode.insertBefore this, nextSibling
        parentNode.removeChild nextSibling
    )
    sort.call(this, comparator).each (i) ->
      placements[i].call getSortable.call(this)
)()