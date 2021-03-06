# Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
# Cryptopus and licensed under the Affero General Public License version 3 or later.
# See the COPYING file at the top-level directory or at
# https://github.com/puzzle/cryptopus.

# scope for global functions
app = window.App ||= {}

class app.ApiUserRemove
  constructor: () ->
    bind.call()

  removeDialog = (elem) ->
    $('<div></div>').appendTo('body')
    .html('<div><h5> Delete Api-User ' + $(elem).parents('.api-user-row').children().first().text().trim() + '?')
    .dialog({
      modal: true, title: 'Remove Api-User', zIndex: 1000, autoOpen: true,
      width: 'auto', resizable: false,
      buttons: {
        Yes: () ->
          removeApiUser(elem)
          $(this).dialog('close')
        No: () ->
          $(this).dialog('close')
      },
      close: () ->
        $(this).remove()
      })

  removeApiUser = (elem) ->
    $.ajax({
      type: "DELETE",
      url: '/api/api_users/' +id(elem)
      success: (data) ->
        $(elem).parents('.api-user-row').remove()
        if(wasLastElement())
          $('#api_users_table').hide()
          $('#api_users_title').text('No Api Users')
    })

  wasLastElement = ->
    $('#api_users_table tr').length == 1

  id = (elem) ->
    $(elem).parents('.api-user-row').attr('id')


  bind = ->
    $(document).on 'click', '#remove-user', (e) ->
      e.preventDefault()
      removeDialog(this)

  new ApiUserRemove
