# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('#insurance_setting_effective_date').datepicker
		dateFormat: 'yy-mm-dd'
		
jQuery ->
	$('#insurance_setting_cancellation_date').datepicker
		dateFormat: 'yy-mm-dd'
		
$(document).ready ->
  $('#code-click').click ->
    $('#code-help').toggle "fast", ->	
    
$(document).ready ->
  $('#name-click').click ->
    $('#name-help').toggle "fast", ->	
    
$(document).ready ->
  $('#weekly-click').click ->
    $('#weekly-help').toggle "fast", ->	
    
$(document).ready ->
  $('#monthly-click').click ->
    $('#monthly-help').toggle "fast", ->	
    
$(document).ready ->
  $('#annual-click').click ->
    $('#annual-help').toggle "fast", ->	
    
$(document).ready ->
  $('#date-click').click ->
    $('#date-help').toggle "fast", ->
    
$(document).ready ->
  $('#cancellation-click').click ->
    $('#cancellation-help').toggle "fast", -> 
     	
$(document).ready ->
  $('#m-mile').click ->
    alert("You should only change the milestones if you've made an entry error.  If the government has announced new milestones, add a new line to the Salary Thresholds table instead, with a new effective date.")
    
$(document).ready ->
  $('#cancel-warning').click ->
    alert("You should only set a cancellation date if the government has announced that this code will no longer be used.  If the code stays in use but the salary milestones are changing, add a new line to the Salary Thresholds table instead, with a new effective date.")  
