# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#event_start_date").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $("#event_end_date").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $("#event_registration_deadline").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
