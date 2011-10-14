# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$("#addrow").live 'click', (event) ->
    row = $('#score_table tbody>tr:last').clone(true);
    $("td input:text", row).val("");
    $("select option:selected", row).attr("selected", false);
    row.insertAfter('#score_table tbody>tr:last');