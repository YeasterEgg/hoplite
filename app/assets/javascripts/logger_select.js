$(document).on('page:load',logDropdown);

$(document).ready(logDropdown);

function logDropdown(){
  $('#logs').on('change', function(){
    $.ajax({
            url : $(this).val(),
            success : function (data) {
              $("#log").html(data);
            }
          });
  });
}
