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
      hideAllMarkers()
      visibleMarkers()
    )

  $("select").change(->
    currentFilters = $('select').val()
    hideAllMarkers()
    visibleMarkers()
    Gmaps.map.adjustMapToBounds()
  )

  filterPrice = (min_price, max_price) -> 

    
  visibleMarkers = ->
    filtered = Gmaps.map.markers
    filtered = _.reject(filtered, (marker) ->
      console.log "#{marker.price < currentPriceFilter.max}"
      marker.price < currentPriceFilter.min || marker.price > currentPriceFilter.max
    )


    filtered = _.filter(filtered, (marker) ->
      if currentFilters
        _.include(currentFilters, marker.market)
      else
        marker
    )

    console.log "fitler count is #{filtered.length}"

    _.each filtered, (marker) ->
      Gmaps.map.showMarker marker

  hideAllMarkers = ->
    _.each Gmaps.map.markers, (marker) ->
      Gmaps.map.hideMarker marker