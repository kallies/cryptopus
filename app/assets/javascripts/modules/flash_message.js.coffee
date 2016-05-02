# Copyright (c) 2008-2016, Puzzle ITC GmbH. This file is part of
# Cryptopus and licensed under the Affero General Public License version 3 or later.
# See the COPYING file at the top-level directory or at
# https://github.com/puzzle/cryptopus.

app = window.App ||= {}

class app.FlashMessage
  constructor: () ->
    @flash_messages = []

  render_messages: ->
    template = HandlebarsTemplates['alert_messages']

    compiled_html = template(@flash_messages)
    $('.message_container').html(compiled_html)

  add: (message) ->
    @flash_messages.push message
    @render_messages()

  bind: ->
    $(document).ajaxComplete ->
      app.flash.flash_messages = []

app.flash = new app.FlashMessage()
app.flash.bind()
