# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#c-absencecode-click').click ->
    $('#c-absencecodes').toggle "fast", ->
    
$(document).ready ->
  $('#paycent-click').click ->
    $('#pay-cent').toggle "fast", ->
    
$(document).ready ->
  $('#sck-click').click ->
    $('#absence-sck').toggle "fast", ->
    
$(document).ready ->
  $('#mxmdays-click').click ->
    $('#mxm-absence').toggle "fast", -> 
    
$(document).ready ->
  $('#docmnts-click').click ->
    $('#docmnts-reqd').toggle "fast", ->
    
$(document).ready ->
  $('#c-absencenote-click').click ->
    $('#c-absence-note').toggle "fast", ->   
