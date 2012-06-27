# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  currentFilters = []

  Gmaps.map.callback = ->

  $(".chzn-select").chosen()

  $("select").change(->
    currentFilters = $('select').val()
    hideAllMarkers()
    visibleMarkers()
    Gmaps.map.adjustMapToBounds()
  )
    
  visibleMarkers = ->
    filtered = Gmaps.map.markers
    filtered = _.filter(filtered, (marker) ->
      _.include(currentFilters, marker.market)
    )

    _.each filtered, (marker) ->
      Gmaps.map.showMarker marker

  hideAllMarkers = ->
    _.each Gmaps.map.markers, (marker) ->
      Gmaps.map.hideMarker marker