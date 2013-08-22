# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#election_close_at").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
