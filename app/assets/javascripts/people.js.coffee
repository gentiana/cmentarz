class App.PeopleFormUpdater
  constructor: (@mainSelect, @subSelect, @url) ->

  update: ->
    @mainSelect.on 'change', =>
      quarter_id = @mainSelect.val()
      $.get @url, {quarter_id: quarter_id}, @updateGraves

  updateGraves: (graves) =>
    options = for grave in graves
      new Option grave.name, grave.id

    empty = new Option "", ""
    options.unshift empty
    @subSelect.html options

$(document).on 'page:change', ->
  return unless $('body.people').length > 0

  updater = new App.PeopleFormUpdater(
    $('#person_quarter')
    $('#person_grave_id')
    '/graves/names'
  )
  updater.update()
