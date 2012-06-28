# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
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

jQuery ->
  
  currentMarketFilters = []
  currentStatusFilters = []
  currentPriceFilter =
    min: Adventure.min_price
    max: Adventure.max_price

  $('#sort').on 'click', (event) ->
    $("#sidebar_adventure_list li").sortElements (a, b) ->
      (if $(a).find('#price').data('price') > $(b).find('#price').data('price') then 1 else -1)

  $('#sort_sold_out').on 'click', (event) ->
    $("#sidebar_adventure_list li").sortElements (a, b) ->
      (if $(a).find('#status').length > $(b).find('#status').length then 1 else -1)
  
  Gmaps.map.callback = ->


  $("#status-toggle .btn").click ->
    val = $(this).val();
    currentStatusFilters = val
    Gmaps.map.resetSidebarContent()
    hideAllMarkers()
    visibleMarkers()
  
  $(".chzn-select").chosen()

  $( "#filtered-rev" ).val( "$" + Adventure.min_price + " - $" + Adventure.max_price )

  $('#price-range').slider(
    range: true,
    animate: true,
    min: Adventure.min_price,
    max: Adventure.max_price,
    values: [ 0, Adventure.max_price ]
    slide: (event, ui) ->
      $("#filtered-price").html "$#{ui.values[0]}  - $  #{ui.values[1]}"
      currentPriceFilter.min = ui.values[0]
      currentPriceFilter.max = ui.values[1]
      Gmaps.map.resetSidebarContent()
      hideAllMarkers()
      visibleMarkers()
    )

  $("select").change(->
    if ($('select').val())
      currentMarketFilters = $('select').val()
    else
      currentMarketFilters = []
    Gmaps.map.resetSidebarContent()
    hideAllMarkers()
    visibleMarkers()
    Gmaps.map.adjustMapToBounds()
  )

  filterPrice = (min_price, max_price) -> 

    
  visibleMarkers = ->
    filtered = Gmaps.map.markers

    if currentStatusFilters != "all"
      filtered = _.filter(filtered, (marker) ->
        if currentStatusFilters == "active"
          marker.sold_out == false
        else
          marker.sold_out == true
      )

    filtered = _.reject(filtered, (marker) ->
      (marker.price < currentPriceFilter.min) || (marker.price > currentPriceFilter.max)
    )

    if (currentMarketFilters.length != 0)
      filtered = _.filter(filtered, (marker) ->
        _.include(currentMarketFilters, marker.market)
      )

    console.log "fitler count is #{filtered.length}"

    _.each filtered, (marker) ->
      Gmaps.map.createSidebar marker
      Gmaps.map.showMarker marker

  hideAllMarkers = ->
    _.each Gmaps.map.markers, (marker) ->
      Gmaps.map.hideMarker marker