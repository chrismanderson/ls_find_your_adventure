# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#market_sidebar li').on 'click', (e) ->
    e.preventDefault()
    lng = $(this).data("lng")
    lat = $(this).data("lat")

    Gmaps.map.map.panTo(new google.maps.LatLng(lat, lng))
  
  # Gmaps.map.callback = ->
  #   i = 0
  #   while i < @markers.length
  #     console.log Gmaps.map.markers[i].market
  #     ++i

  # 