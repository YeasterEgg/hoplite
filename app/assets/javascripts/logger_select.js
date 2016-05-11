$(document).ready(function(){
  $('#logs').on('change', function(){
    $.ajax({
            url : $(this).val(),
            success : function (data) {
              $("#log").html(data);
            }
          });
  });
})
