ready = ->
  $('.subscription').bind 'ajax:success', (e) ->
    question = e.detail[0].question
    subscribed = e.detail[0].subscribed

    if (subscribed)
      $('.subscription')
        .html("<a data-remote=true rel=nofollow data-method=delete href=/questions/#{question.id}/subscriptions>Unsubscribe</a>")
    else
      $('.subscription')
        .html("<a data-remote=true rel=nofollow data-method=post href=/questions/#{question.id}/subscriptions>Subscribe</a>")

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)