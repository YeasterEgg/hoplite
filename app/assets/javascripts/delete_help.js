$(document).on('page:load',deleteHelp);

$(document).ready(deleteHelp);


function deleteHelp(){
  $('#delete_help').on('click', function(){
    event.preventDefault;
    console.log($('.selector_for_text').val());
    $.ajax({
      type: 'DELETE',
      url: $('.selector_for_text').val(),
      success: function() {
        window.location.reload(true);
      }
    });
  })
}
