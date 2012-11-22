# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('#holiday_start_date').datepicker
		dateFormat: 'yy-mm-dd'
    
	$('#holiday_end_date').datepicker
		dateFormat: 'yy-mm-dd'
