class @FilterMaster
  constructor: ->
    @currentDateFilter = 
      start: null
      end: null

  @filterDate: ->
    end_date = $("#to").datepicker "getDate"
    start_date = $("#from").datepicker "getDate"
    @currentDateFilter.start = start_date
    @currentDateFilter.end = end_date
    Gmaps.map.resetSidebarContent()
    hideAllMarkers()
    visibleMarkers()