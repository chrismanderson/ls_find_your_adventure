# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  currentMarketFilters = []
  currentDateFilter =
    start: null
    end: null
  currentStatusFilters = 'all'
  currentPriceFilter =
    min: Adventure.min_price
    max: Adventure.max_price

  currentDurationFilter =
    min: 0
    max: 12


  $("#from").datepicker
    defaultDate: "+1w"
    changeMonth: true
    numberOfMonths: 3
    onSelect: (selectedDate) ->
      $("#to").datepicker "option", "minDate", selectedDate
      if datePickerCheck() == true
        filterDate()

  $("#to").datepicker
    defaultDate: "+1w"
    changeMonth: true
    numberOfMonths: 3
    onSelect: (selectedDate) ->
      $("#from").datepicker "option", "maxDate", selectedDate
      if datePickerCheck() == true
        filterDate()

  datePickerCheck = ->
    !($("#to").datepicker("getDate") == null || $("#from").datepicker("getDate") == null)


  filterDate = ->
    end_date = $("#to").datepicker "getDate"
    start_date = $("#from").datepicker "getDate"
    currentDateFilter.start = start_date
    currentDateFilter.end = end_date
    Gmaps.map.resetSidebarContent()
    hideAllMarkers()
    visibleMarkers()
  

  $('#sort').on 'click', (event) ->
    $("#sidebar_adventure_list li").sortElements (a, b) ->
      (if $(a).find('#price').data('price') > $(b).find('#price').data('price') then 1 else -1)

  $('#sort_sold_out').on 'click', (event) ->
    $("#sidebar_adventure_list li").sortElements (a, b) ->
      (if $(a).find('#status').length > $(b).find('#status').length then 1 else -1)

  $('#sort_duration').on 'click', (event) ->
    $("#sidebar_adventure_list li").sortElements (a, b) ->
      (if $(a).find('#duration').data('duration') > $(b).find('#duration').data('duration')  then 1 else -1)
  
  checkUserLocation = ->
    if (Gmaps.map.userLocation != null)
      loadMarkets()
      Gmaps.map.createMarker
        Lat: Gmaps.map.userLocation.lat()
        Lng: Gmaps.map.userLocation.lng()
        rich_marker: null
        marker_picture: ""
    else
      setTimeout(checkUserLocation, 2000);

  Gmaps.map.callback = ->
    checkUserLocation()

  loadMarkets = ->
    $.getJSON('/markets.json', alertMarkets)

  alertMarkets = (markets) ->
    $.get "/markets/nearest",
      lat: Gmaps.map.userLocation.lat()
      lng: Gmaps.map.userLocation.lng()
      radius: 500
    , (data) ->
        $("select").val([data[0].city, data[1].city])
        $("select").trigger("liszt:updated");
        if ($('select').val())
          currentMarketFilters = $('select').val()
        else
          currentMarketFilters = []
        Gmaps.map.resetSidebarContent()
        hideAllMarkers()
        visibleMarkers()
        Gmaps.map.adjustMapToBounds()


  $("#status-toggle .btn").click ->
    val = $(this).val();
    currentStatusFilters = val
    Gmaps.map.resetSidebarContent()
    hideAllMarkers()
    visibleMarkers()
  
  $(".chzn-select").chosen()

  $( "#filtered-rev" ).val( "$" + Adventure.min_price + " - $" + Adventure.max_price )

  $('#duration-range').slider(
    range: true,
    animate: true,
    step: 0.5,
    min: 0,
    max: 12,
    values: [ 0, 12 ]
    slide: (event, ui) ->
      $("#filtered-price").html "$#{ui.values[0]}  - $  #{ui.values[1]}"
      currentDurationFilter.min = ui.values[0]
      currentDurationFilter.max = ui.values[1]
      Gmaps.map.resetSidebarContent()
      hideAllMarkers()
      visibleMarkers()
    )

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

  $("select").chosen().change(->
    if ($('select').val())
      currentMarketFilters = $('select').val()
    else
      currentMarketFilters = []
    Gmaps.map.resetSidebarContent()
    hideAllMarkers()
    visibleMarkers()
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
      (marker.duration < currentDurationFilter.min) || (marker.duration > currentDurationFilter.max)
    )

    filtered = _.reject(filtered, (marker) ->
      (marker.price < currentPriceFilter.min) || (marker.price > currentPriceFilter.max)
    )

    if (currentMarketFilters.length != 0)
      filtered = _.filter(filtered, (marker) ->
        _.include(currentMarketFilters, marker.market)
      )

    if (currentDateFilter.start != null && currentDateFilter.end != null)
      filtered = _.filter(filtered, (marker) ->
        _.any(marker.dates, (date) ->
          testDate = new Date(date.date)
          console.log "testDate: #{testDate} filterStart #{currentDateFilter.start} filterEnd #{currentDateFilter.end}"
          currentDateFilter.start <= testDate && testDate <= currentDateFilter.end
        ) 
      )


    _.each filtered, (marker) ->
      Gmaps.map.createSidebar marker
      Gmaps.map.showMarker marker

    Gmaps.map.adjustMapToBounds()

  hideAllMarkers = ->
    _.each Gmaps.map.markers, (marker) ->
      Gmaps.map.hideMarker marker