# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#absencecode-click').click ->
    $('#biz-absencecodes').toggle "fast", ->
    
$(document).ready ->
  $('#paypcent-click').click ->
    $('#pay-pcent').toggle "fast", ->
    
$(document).ready ->
  $('#sick-click').click ->
    $('#absence-sick').toggle "fast", ->
    
$(document).ready ->
  $('#mxdays-click').click ->
    $('#mx-absence').toggle "fast", ->
    
$(document).ready ->
  $('#docmts-click').click ->
    $('#docmts-reqd').toggle "fast", ->
    
$(document).ready ->
  $('#absencenote-click').click ->
    $('#absence-note').toggle "fast", ->
