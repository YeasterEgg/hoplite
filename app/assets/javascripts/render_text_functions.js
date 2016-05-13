// Gets the choice from the dropdown and calls addTextByDelay with its Ajax response

function catchDropdown(dropdownElement, writingSpaceElement, delay){
  dropdownElement.on('change', function(){
    $.ajax({
            url : $(this).val(),
            success : function(data){
              writingSpaceElement.html('');
              addTextByDelay (data,writingSpaceElement,delay);
            }
          });
  });
}

// Display text in an alement one character at a time

function addTextByDelay(text,element,delay){
  if(!element){
    element = $("body");
  }
  if(!delay){
    delay = 300;
  }
  if(text.length >0){
    element.append(text[0]);
    setTimeout(
      function(){
        addTextByDelay(text.slice(1),element,delay);
      },delay
    );
  }
}

// Allows to delete the selected element in the dropdown menu

function deleteText(dropdownElement, buttonElement){
  buttonElement.on('click', function(){
    event.preventDefault;
    $.ajax({
      type: 'DELETE',
      url: dropdownElement.val(),
      success: function() {
        window.location.reload(true);
      }
    });
  })
}

// Display a list when clicking on title

function showData(title, list, delay){
  title.on('click', function(){
    list.slideToggle(delay);
  })
}
