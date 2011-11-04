# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#event_start_date").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $("#event_end_date").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $("#event_registration_deadline").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});

  $('textarea.general_information').tinymce({theme: 'advanced'});
  $('textarea.competitor_information').tinymce({theme: 'advanced'});
  $('textarea.schedule').tinymce({theme: 'advanced'});
  $('textarea.directions').tinymce({theme: 'advanced'});
  $('textarea.accommodations').tinymce({theme: 'advanced'});
  $('textarea.banquet').tinymce({theme: 'advanced'});
  $('textarea.auction').tinymce({theme: 'advanced'});
  $('textarea.sponsors').tinymce({theme: 'advanced'});