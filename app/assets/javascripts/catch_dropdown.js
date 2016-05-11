$(document).on('page:load',catchDropdown);

$(document).ready(catchDropdown);

function catchDropdown(){
  $('.selector_for_text').on('change', function(){
    $.ajax({
            url : $(this).val(),
            success : function(data){
              $('#white_paper').html('');
              addTextByDelay (data,$('#white_paper'),5);
            }
          });
  });
}

var addTextByDelay = function(text,elem,delay){
    if(!elem){
        elem = $("body");
    }
    if(!delay){
        delay = 300;
    }
    if(text.length >0){
        elem.append(text[0]);
        setTimeout(
            function(){
                //Slice text by 1 character and call function again
                addTextByDelay(text.slice(1),elem,delay);
             },delay
            );
    }
}

