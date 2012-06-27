# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  currentFilters = []
  currentPriceFilter =
    min: Adventure.min_price
    max: Adventure.max_price

  Gmaps.map.callback = ->

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
      currentFilters = $('select').val()
    else
      currentFilters = []
    hideAllMarkers()
    visibleMarkers()
    Gmaps.map.adjustMapToBounds()
  )

  filterPrice = (min_price, max_price) -> 

    
  visibleMarkers = ->
    filtered = Gmaps.map.markers
    filtered = _.reject(filtered, (marker) ->
      (marker.price < currentPriceFilter.min) || (marker.price > currentPriceFilter.max)
    )

    if (currentFilters.length != 0)
      filtered = _.filter(filtered, (marker) ->
        _.include(currentFilters, marker.market)
      )

    console.log "fitler count is #{filtered.length}"

    _.each filtered, (marker) ->
      Gmaps.map.createSidebar marker
      Gmaps.map.showMarker marker

  hideAllMarkers = ->
    _.each Gmaps.map.markers, (marker) ->
      Gmaps.map.hideMarker marker