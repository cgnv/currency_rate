# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  return unless page.controller() == 'rates' && page.action() == 'index'
  fetchRate = ->
    console.log 'Sending AJAX request...'
    $.ajax(
      url: '/rates.json'
      type: 'GET'
      contentType: 'application/json'
    ).done((msg) ->
      console.log 'success'
      console.log msg
      $('#rate').html msg['value']
      $('#date').html msg['date']
    ).fail(->
      console.log 'error'
    ).always ->
      console.log 'Waiting ' + 5000 / 1000 + ' seconds'
      setTimeout fetchRate, 5000

  fetchRate()