google.charts.load('current', {'packages':['corechart']});

$(document).on('page:load',postponedFunctions);
$(document).ready(postponedFunctions);

function postponedFunctions(){

  // Text rendering functions
  catchDropdown($('.selector_for_text'), $('#white_paper'), 5);
  deleteText($('.selector_for_text'), $('#delete_text'));
  showData($('#ticket_size_title'), $('#tickets_size'), 666)

  // Google Plot functions
  callbackForGoogle($('#product_details')) // It actually causes a fallback on itself

  // Product Pages (index and show) functions
  surpriseClick($('.comic'), $('.surprise'), $('.wrap'));
  addClassIfOver($('.real_probable_ratio'),5,'red_text');
  alternateColorTable($('.product_row'),'#d0d0d0','#f0f0f0');

}
