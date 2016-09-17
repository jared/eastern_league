# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#competitor_form').validate()

  addMember = (name, id) ->
    dom_id = 'competitor_' + id
    $('<li id="'+dom_id+'">').html(name + '<a class="remove_team_member" href="#" onclick="$(this).parents(\'li\').remove();"><img alt="Icn trash" src="/assets/icons/icn_trash.png"></a>').appendTo "#active_members"
    $("<input type='hidden' name='competitor[competitor_ids][]'>").val(id).appendTo "#"+dom_id

  $("#team_member_lookup").autocomplete
    source: '/users/search.json'
    minLength: 2
    select: (event, ui) ->
      addMember ui.item.label, ui.item.competitor_id
      return

  $(".remove_team_member").on 'click', (elem) ->
    $(elem.target).parents('li').remove()
