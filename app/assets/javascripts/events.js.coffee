# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#event_start_date").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $("#event_end_date").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $("#event_registration_deadline").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});

  tinymce.init({
    selector: "textarea.editor",
    theme: "modern",
    plugins: [
         "advlist autolink link lists charmap print preview hr anchor pagebreak spellchecker",
         "searchreplace wordcount visualblocks visualchars code insertdatetime media nonbreaking",
         "save table contextmenu directionality emoticons template paste textcolor"
    ],
    toolbar: "styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link | forecolor backcolor emoticons code",
    })
  