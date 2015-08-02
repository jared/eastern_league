# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#announcement_created_at").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  tinymce.init({
    selector: "textarea.announcement_body",
    plugins: [
         "autolink link hr anchor pagebreak",
         "searchreplace visualblocks visualchars code insertdatetime nonbreaking",
         "table contextmenu directionality emoticons template paste textcolor"
    ],
    toolbar: [
      "styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link forecolor backcolor emoticons code"
    ]
    })
