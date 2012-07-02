class @DatePicker
  @initialize: (start_direction, opposite_direction, date) =>
    $(start_direction).datepicker
      defaultDate: "+1w"
      changeMonth: true
      numberOfMonths: 1
      onSelect: (selectedDate) ->
        $(opposite_direction).datepicker "option", date, selectedDate
        if DatePicker.check() == true
          FilterMaster.filterDate()

  @check: ->
    !($("#to").datepicker("getDate") == null || $("#from").datepicker("getDate") == null)
