# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#user_member_since").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $("#user_current_through_date").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $('textarea.competitor_bio').tinymce({theme: 'simple'});