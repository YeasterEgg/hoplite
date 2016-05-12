$(document).on('page:load',showData);

$(document).ready(showData);

function showData(){
  $('#ticket_size_title').on('click', function(){
    $('#tickets_size').slideToggle(666);
  })
}
