$(document).ready(function(){
  $('.comic').on('click',function(){
    event.preventDefault();
    alert('ciao');
    $("#foo").append("<div>hello world</div>")
  })
})
