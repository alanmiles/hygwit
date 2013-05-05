# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->
  $('#positions-click').click ->
    $('#job-positions').toggle "fast", ->
    
$(document).ready ->
  $('#occupation-click').click ->
    $('#job-occupations').toggle "fast", ->
    
$(document).ready ->
  $('#rank-click').click ->
    $('#job-ranks').toggle "fast", ->
    
$(document).ready ->
  $('#curr-job-click').click ->
    $('#job-current').toggle "fast", ->
   
