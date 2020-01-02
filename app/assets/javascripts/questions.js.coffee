ready = ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow', text: 'question'
    ,
    received: (data) ->
      question = JSON.parse(data.locals['question'])
      $('tbody').append("<tr><td><a href=/questions/#{question.id}>#{question.title}</a></td> <td>#{question.body}</td><td></td></tr>");
  })

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)