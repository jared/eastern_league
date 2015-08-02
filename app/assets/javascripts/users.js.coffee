# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#user_member_since").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  $("#user_current_through_date").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
  
  tinymce.init({
    selector: "#user_competitor_attributes_bio",
    theme: "modern",
    plugins: [
         "advlist autolink link lists charmap print preview hr anchor pagebreak spellchecker",
         "searchreplace wordcount visualblocks visualchars code insertdatetime media nonbreaking",
         "save table contextmenu directionality emoticons template paste textcolor"
    ],
    toolbar: "styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link | forecolor backcolor emoticons code",
    })