# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('#ethnic_group_cancellation_date').datepicker
		dateFormat: 'yy-mm-dd'

$(document).ready ->
  $('#val-click').click ->
    $('#c-val').toggle "fast", ->

$(document).ready ->
  $('#month-click').click ->
    $('#c-month').toggle "fast", ->

$(document).ready ->
  $('#sick-click').click ->
    $('#sick-acc').toggle "fast", ->
    
$(document).ready ->
  $('#loan-click').click ->
    $('#loan-ded').toggle "fast", ->
      
$(document).ready ->
  $('#ram-click').click ->
    $('#ram-hours').toggle "fast", ->
    
$(document).ready ->
  $('#nw-click').click ->
    $('#nw-hours').toggle "fast", ->
    
$(document).ready ->
  $('#ot-click').click ->
    $('#ot-rates').toggle "fast", ->
    
$(document).ready ->
  $('#gratuity-on-click').click ->
    $('#gratuity-on').toggle "fast", ->
    
$(document).ready ->
  $('#eth-click').click ->
    $('#ethnic').toggle "fast", ->
    
$(document).ready ->
  $('#disabled-click').click ->
    $('#disabled').toggle "fast", ->
    
$(document).ready ->
  $('#gratuity-click').click ->
    $('#gratuity-display').toggle "fast", ->
    

