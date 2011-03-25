/*
 * Smart event highlighting
 * Handles for when events span rows, or don't have a background color
 */
Event.observe(window, "load", function() {
  var highlight_color = "#2EAC6A";
  
  // highlight events that have a background color
  $$(".ec-event-bg").each(function(ele) {
    ele.observe("mouseover", function(evt) {
      event_id = ele.readAttribute("data-event-id");
      event_class_name = ele.readAttribute("data-event-class");
      $("ec-"+event_class_name+"-"+event_id).setStyle({ backgroundColor: highlight_color });
    });
    ele.observe("mouseout", function(evt) {
      event_id = ele.readAttribute("data-event-id");
      event_class_name = ele.readAttribute("data-event-class");
      event_color = ele.readAttribute("data-color");
      $("ec-"+event_class_name+"-"+event_id).setStyle({ backgroundColor: event_color });
    });
  });
  
  // highlight events that don't have a background color
  $$(".ec-event-no-bg").each(function(ele) {
    ele.observe("mouseover", function(evt) {
      ele.setStyle({ color: "white" });
      ele.select("a").each(function(link) {
        link.setStyle({ color: "white" });
      });
      ele.select(".ec-bullet").each(function(bullet) {
        bullet.setStyle({ backgroundColor: "white" });
      });
      ele.setStyle({ backgroundColor: highlight_color });
    });
    ele.observe("mouseout", function(evt) {
      event_color = ele.readAttribute("data-color");
      ele.setStyle({ color: event_color });
      ele.select("a").each(function(link) {
        link.setStyle({ color: event_color });
      });
      ele.select(".ec-bullet").each(function(bullet) {
        bullet.setStyle({ backgroundColor: event_color });
      });
      ele.setStyle({ backgroundColor: "transparent" });
    });
  });
});