initializeSorter = (params) ->
    _.each params, (param) ->
      $("#sort_#{param}").on 'click', (event) ->
        $("#sidebar_adventure_list li").sortElements (a, b) ->
          (if $(a).find("##{param}").data("#{param}") > $(b).find("##{param}").data("#{param}") then 1 else -1)

jQuery ->

  # Establishing some filter constants
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

  # starting up 
  if document.cookie.search(/(^|;)visited=/) > -1
    console.log "Already visited."
  else
    document.cookie = "visited=true;max-age=" + 60 * 60 * 24 * 10
    $('#myModal').modal('show')

  initializeSorter(["duration","price"])
  $("#filtered-duration").html "2 hours - 12 hours"
  $(".chzn-select").chosen()
  $( "#filtered-price").html( "$" + Adventure.min_price + " - $" + Adventure.max_price )
  
  filterCalendar = ->
    currentDateFilter.start = $("#from").datepicker "getDate"
    currentDateFilter.end = $("#to").datepicker "getDate"
    runFilters()

  # datepicker methods
  $("#from").datepicker
    defaultDate: "+1w"
    changeMonth: true
    numberOfMonths: 1
    onSelect: (selectedDate) ->
      $("#to").datepicker "option", "minDate", selectedDate
      if datePickerCheck() == true
        filterCalendar()

  $("#to").datepicker
    defaultDate: "+1w"
    changeMonth: true
    numberOfMonths: 1
    onSelect: (selectedDate) ->
      $("#from").datepicker "option", "maxDate", selectedDate
      if datePickerCheck() == true
        filterCalendar()

  datePickerCheck = ->
    !($("#to").datepicker("getDate") == null || $("#from").datepicker("getDate") == null)


  # sorters
  $('#sort_sold_out').on 'click', (event) ->
    $("#sidebar_adventure_list li").sortElements (a, b) ->
      (if $(a).find('#status').length > $(b).find('#status').length then 1 else -1)

  # detecting user location
  fetchUserLocation = ->
    if (Gmaps.map.userLocation != null)
      alertMarkets Gmaps.map.userLocation
    else
      setTimeout(fetchUserLocation, 2000);

  Gmaps.map.geolocationFailure = (browser_support) ->
    if browser_support is true
      runFilters()
    else
      runFilters()

  Gmaps.map.callback = ->  
    Gmaps.map.adjustMapToBounds()
    fetchUserLocation()

  alertMarkets = (userLocation) ->
    console.log "am i getting called"
    $.get "/api/v1/markets/nearest",
      lat: userLocation.lat()
      lng: userLocation.lng()
      radius: 500
    , (data) ->
        $("select").val([data[0].city, data[1].city])
        $("select").trigger("liszt:updated");
        if ($('select').val())
          currentMarketFilters = $('select').val()
        else
          currentMarketFilters = []
        runFilters()

  $("#status-toggle .btn").click ->
    val = $(this).val();
    currentStatusFilters = val
    runFilters()

  $('#duration-range').slider(
    range: true,
    animate: true,
    step: 0.5,
    min: 0,
    max: 12,
    values: [ 0, 12 ]
    slide: (event, ui) ->
      $("#filtered-duration").html "#{ui.values[0]} hours -   #{ui.values[1]} hours"
      currentDurationFilter.min = ui.values[0]
      currentDurationFilter.max = ui.values[1]
      runFilters()
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
      runFilters()
    )

  $("select").chosen().change(->
    if ($('select').val())
      currentMarketFilters = $('select').val()
    else
      currentMarketFilters = []
    runFilters()
  )

  # various filters

  filterDuration = (markers) ->
    _.reject(markers, (marker) ->
      (marker.duration < currentDurationFilter.min) || (marker.duration > currentDurationFilter.max)
    )

  filterPrice = (markers) ->
    _.reject(markers, (marker) ->
      (marker.price < currentPriceFilter.min) || (marker.price > currentPriceFilter.max)
    )

  filterMarket = (markers) ->
    _.filter(markers, (marker) ->
      _.include(currentMarketFilters, marker.market)
    )

  filterStatus = (markers) ->
    _.filter(markers, (marker) ->
      if currentStatusFilters == "active"
        marker.sold_out == false
      else
        marker.sold_out == true
    )

  filterDate = (markers) ->
    console.log currentDateFilter.end
    _.filter(markers, (marker) ->
      _.any(marker.dates, (date) ->
        testDate = new Date(date.date)
        currentDateFilter.start <= testDate && testDate <= currentDateFilter.end
      ) 
    )

  # main method to display all the markers
  visibleMarkers = ->
    filtered = Gmaps.map.markers
    if currentStatusFilters != "all"
      filtered = filterStatus filtered
    filtered = filterDuration filtered
    filtered = filterPrice filtered
    if (currentMarketFilters.length != 0)
      filtered = filterMarket filtered
    if (currentDateFilter.start != null && currentDateFilter.end != null)
      filtered = filterDate filtered

    # display each of the markers
    _.each filtered, (marker) ->
      Gmaps.map.createSidebar marker
      Gmaps.map.showMarker marker

    # reset the bounds of the map
    Gmaps.map.adjustMapToBounds()

  hideAllMarkers = ->
    _.each Gmaps.map.markers, (marker) ->
      Gmaps.map.hideMarker marker

  runFilters = ->
    Gmaps.map.resetSidebarContent()
    hideAllMarkers()
    visibleMarkers()