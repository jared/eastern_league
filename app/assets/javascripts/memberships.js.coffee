# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#membership_membership_plan_id").change ->
    switch $(this).val()
      when "1" then familyPrice = "$8.00"
      when "3" then familyPrice = "$12.00"
    $('.family_price').text(familyPrice)

  $(".add_another").click((event) ->
    event.preventDefault()
    $(".additional_members").append("<div class=\"clear\"><br /><input id=\"additional_members\" type=\"text\" name=\"additional_members[]\"><a href=\"#\" onclick=\"$(this).closest('div').remove();return false;\">X</a></div>")
  )

  $("#new_membership").validate();
  $("input.email").each ->
    $(this).rules("add", {
      required: true,
      email: true,
      messages: {
        required: "Specify a valid email"
      }
    });