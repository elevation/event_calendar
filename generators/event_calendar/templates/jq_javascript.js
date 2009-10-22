$(document).ready(function() {
  $(".event").live("mouseover", function() {
    $(this).css("background-color", "#2EAC6A");
  });
  $(".event").live("mouseout", function() {
    $(this).css("background-color", "#9aa4ad");
  });
})
