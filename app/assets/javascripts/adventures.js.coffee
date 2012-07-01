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
    console.log "FILTERING"
    end_date = $("#to").datepicker "getDate"
    start_date = $("#from").datepicker "getDate"
    currentDateFilter.start = start_date
    currentDateFilter.end = end_date
    console.log $.datepicker.formatDate('mm/dd/yy', start_date)
    Gmaps.map.resetSidebarContent()
    hideAllMarkers()
    visibleMarkers()
  

  $('#sort').on 'click', (event) ->
    $("#sidebar_adventure_list li").sortElements (a, b) ->
      (if $(a).find('#price').data('price') > $(b).find('#price').data('price') then 1 else -1)

  $('#sort_sold_out').on 'click', (event) ->
    $("#sidebar_adventure_list li").sortElements (a, b) ->
      (if $(a).find('#status').length > $(b).find('#status').length then 1 else -1)
  
  checkUserLocation = ->
    if (Gmaps.map.userLocation != null)
      loadMarkets()
      console.log Gmaps.map.userLocation.lng()
      console.log Gmaps.map.userLocation.lat()
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
    console.log markets
    $.get "/markets/nearest",
      lat: Gmaps.map.userLocation.lat()
      lng: Gmaps.map.userLocation.lng()
      radius: 500
    , (data) ->
        console.log "Data Loaded: " + data[0].city
        console.log data[1].city
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
    Gmaps.map.adjustMapToBounds()
  )

  filterPrice = (min_price, max_price) -> 

    
  visibleMarkers = ->
    filtered = Gmaps.map.markers
    console.log currentStatusFilters

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

    if (currentDateFilter.start != null && currentDateFilter.end != null)
      console.log "FILTERING"
      filtered = _.filter(filtered, (marker) ->
        _.any(marker.dates, (date) ->
          testDate = new Date(date.date)
          console.log marker.title
          console.log "testDate: #{testDate} filterStart #{currentDateFilter.start} filterEnd #{currentDateFilter.end}"
          currentDateFilter.start <= testDate && testDate <= currentDateFilter.end
        ) 
      )

    console.log "fitler count is #{filtered.length}"

    _.each filtered, (marker) ->
      Gmaps.map.createSidebar marker
      
      Gmaps.map.showMarker marker

  hideAllMarkers = ->
    _.each Gmaps.map.markers, (marker) ->
      Gmaps.map.hideMarker marker