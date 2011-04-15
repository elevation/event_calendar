window.addEvent('load', function() {
    var highlight_color = "#2EAC6A";

    new Tips('.ec-event a');

    $$(".ec-event-bg").each(function(el) {
        el.addEvent('mouseover', function(e) {
            event_id = el.getProperty('data-event-id');
            $$(".ec-event-"+event_id).each(function(ele) {
                ele.setStyle('background-color',highlight_color);
            });
        });
        el.addEvent('mouseout', function(e) {
            event_color = el.getProperty('data-color');
            event_id = el.getProperty('data-event-id');
            $$(".ec-event-"+event_id).each(function(ele) {
                ele.setStyle('background-color',event_color);
            });
        });
    });

    $$(".ec-event-no-bg").each(function(el) {
        el.addEvent('mouseover', function(e) {
            el.setStyle({ 'color': '#FFF' });
            el.getChildren('a').each(function(link) {
                link.setStyle('color','#FFF');
            });
            el.getChildren('.ec-bullet').each(function(bullet) {
                bullet.setStyle('background-color','#FFF');
            });
            el.setStyle('background-color',highlight_color);
        });
        el.addEvent('mouseout', function(e) {
            event_color = el.getProperty('data-color');
            el.setStyle({'color': event_color});
            el.getChildren('a').each(function(link) {
                link.setStyle('color',event_color);
            });
            el.getChildren('.ec-bullet').each(function(bullet) {
                bullet.setStyle('background-color',event_color);
            });
            el.setStyle('background-color','transparent');
        })
    });
});