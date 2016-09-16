# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  tinymce.init({
    selector: "textarea.raffle_item_description_body",
    plugins: [
         "autolink link hr anchor pagebreak",
         "searchreplace visualblocks visualchars code insertdatetime nonbreaking",
         "table contextmenu directionality emoticons template paste textcolor"
    ],
    toolbar: [
      "styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link forecolor backcolor emoticons code"
    ]
    })
  tinymce.init({
    selector: "textarea.jacket_description",
    plugins: [
         "autolink link hr anchor pagebreak",
         "searchreplace visualblocks visualchars code insertdatetime nonbreaking",
         "table contextmenu directionality emoticons template paste textcolor"
    ],
    toolbar: [
      "styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link forecolor backcolor emoticons code"
    ]
    })
