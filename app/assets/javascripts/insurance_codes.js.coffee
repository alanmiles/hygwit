# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('#insurance_code_cancelled').datepicker
		dateFormat: 'yy-mm-dd'
		
$(document).ready ->
  $('#code-fixed').click ->
    $('#code-explain-fix').toggle "fast", ->		

$(document).ready ->
  $('#explain').click ->
    $('#explain-note').toggle "fast", ->
    
$(document).ready ->
  $('#ccl').click ->
    $('#ccl-note').toggle "fast", ->
    
$(document).ready ->
  $('#code-entry').click ->
    $('#code-entry-note').toggle "fast", ->				
