# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('#insurance_setting_effective_date').datepicker
		dateFormat: 'yy-mm-dd'
		
$ ->
	$('#insurance_setting_cancellation_date').datepicker
		dateFormat: 'yy-mm-dd'

$ ->
  $('.icon-question-sign').removeClass('help-button')
  
$ ->
  $('#code-click').click ->
    $('#code-help').toggle "fast", ->	
    
$ ->
  $('#name-click').click ->
    $('#name-help').toggle "fast", ->	
    
$ ->
  $('#weekly-click').click ->
    $('#weekly-help').toggle "fast", ->	
    
$ ->
  $('#monthly-click').click ->
    $('#monthly-help').toggle "fast", ->	
    
$ ->
  $('#annual-click').click ->
    $('#annual-help').toggle "fast", ->	
    
$ ->
  $('#date-click').click ->
    $('#date-help').toggle "fast", ->
    
$ ->
  $('#cancellation-click').click ->
    $('#cancellation-help').toggle "fast", ->
    
$ ->
  $('#m-mile').click ->
    alert("You should only change the milestones if you've made an entry error.  If the government has announced new milestones, add a new line to the Salary Thresholds table instead, with a new effective date.")
    
$ ->
  $('#cancel-warning').click ->
    alert("You should only set a cancellation date if the government has announced that this code will no longer be used.  If the code stays in use but the salary milestones are changing, add a new line to the Salary Thresholds table instead, with a new effective date.")  
