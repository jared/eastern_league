# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#event_registration_form").validate()
  $(".mark_paid_link").click -> 
    $(this).parents('tr').find('form.payment_form').submit()