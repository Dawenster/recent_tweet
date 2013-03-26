$(function(){

  $.ajax({
    url: window.location,
    type: "get"
  }).done(function(inner_content){
    $('body').html(inner_content);
  });

});
