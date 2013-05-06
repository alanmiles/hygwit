# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#abscode-click').click ->
    $('#biz-abscodes').toggle "fast", ->
    
$(document).ready ->
  $('#paypercent-click').click ->
    $('#pay-percent').toggle "fast", ->
    
$(document).ready ->
  $('#sickness-click').click ->
    $('#abs-sick').toggle "fast", ->
    
$(document).ready ->
  $('#maxdays-click').click ->
    $('#max-absence').toggle "fast", ->
    
$(document).ready ->
  $('#docs-click').click ->
    $('#docs-reqd').toggle "fast", ->
    
$(document).ready ->
  $('#absnote-click').click ->
    $('#abs-note').toggle "fast", ->
    
$(document).ready ->
  $('#abscurrent-click').click ->
    $('#abs-current').toggle "fast", ->
