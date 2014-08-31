ready = ->
  $('#person_quarter').on 'change', ->
    quarter_id = @.value
    $.get "/graves/names", {quarter_id: quarter_id}, updateGraves

updateGraves = (graves) ->
  options = $.map graves, (grave, i) ->
    new Option grave.name, grave.id
  
  empty = new Option "", ""
  options.unshift empty
  $('#person_grave_id').html options

$(document).ready ready
$(document).on 'page:load', ready
