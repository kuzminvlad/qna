ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', text: 'answer'
    ,
    received: (data) ->
      answer = JSON.parse(data.locals['answer'])
      $(".answers").append("<div>Новый ответ от пользователей: <br><div>#{answer.body}</div></div>");
  })

$(document).ready(ready) 
$(document).on('page:load', ready) 
$(document).on('page:update', ready)