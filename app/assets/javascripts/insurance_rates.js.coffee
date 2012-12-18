# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('#insurance_rate_effective').datepicker
		dateFormat: 'yy-mm-dd'
		
$(document).ready ->
  $('#rebate-click').click ->
    $('#rebates').toggle "fast", ->
    
$(document).ready ->
  $('#contribution-click').click ->
    $('#contributions').toggle "fast", ->
    
$(document).ready ->
  $('#edate-click').click ->
    $('#edates').toggle "fast", ->
    
$(document).ready ->
  $('#threshold-click').click ->
    $('#thresholds').toggle "fast", ->
    
$(document).ready ->
  $('#ceiling-click').click ->
    $('#ceilings').toggle "fast", ->
    
$(document).ready ->
  $('#cancellation-click').click ->
    $('#cancellations').toggle "fast", ->