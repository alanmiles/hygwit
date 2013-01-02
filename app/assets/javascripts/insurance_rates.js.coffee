# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('#insurance_rate_effective').datepicker
		dateFormat: 'yy-mm-dd'
		
$ ->
  $('.icon-question-sign').removeClass('help-button')
   
$ ->
  $('#rebate-click').click ->
    $('#rebates').toggle "fast", ->
    
$ ->
  $('#contribution-click').click ->
    $('#contributions').toggle "fast", ->
    
$ ->
  $('#edate-click').click ->
    $('#edates').toggle "fast", ->
    
$ ->
  $('#threshold-click').click ->
    $('#thresholds').toggle "fast", ->
    
$ ->
  $('#ceiling-click').click ->
    $('#ceilings').toggle "fast", ->
    
$ ->
  $('#cancellation-click').click ->
    $('#cancellations').toggle "fast", ->
