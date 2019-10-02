ready = ->
  $('.vote_contol').bind 'ajax:success', (e) -> #e.detail[0] -> data
    id = e.detail[0].votable_id 
    score = e.detail[0].score
    model = e.detail[0].model

    $('div.raiting-'+ model + id).text('Raiting:' + score);
    if (e.detail[0].voted)
      $('#voteup-'+ model + id).attr('disabled',true);
      $('#votedown-'+ model + id).attr('disabled',true);
      $('#voteclean-'+ model + id).removeAttr('disabled');
    else
      $('#voteup-'+ model + id).removeAttr('disabled');
      $('#votedown-'+ model + id).removeAttr('disabled');
      $('#voteclean-'+ model + id).attr('disabled',true);

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)