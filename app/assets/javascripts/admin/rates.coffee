# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  return unless page.controller() == 'admin/rates'
  $('#time_zone').set_timezone format: 'city'
  ar = $('#rate_expire_at').val().split(/\.|[\s]|:/)
  if ar.length == 5
    ar[3] = (Number(ar[3]) - ((new Date).getTimezoneOffset() / 60)).toString()
    $('#rate_expire_at').val "#{ar[0]}.#{ar[1]}.#{ar[2]} #{ar[3]}:#{ar[4]}"
