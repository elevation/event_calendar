class EventCalendarGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "stylesheet.css", "public/stylesheets/event_calendar.css"
      m.file "javascript.js", "public/javascripts/event_calendar.js"
      m.directory "public/images/event_calendar"
      m.file "85_bg.gif", "public/images/event_calendar/85_bg.gif"
      m.file "120_bg.gif", "public/images/event_calendar/120_bg.gif"
    end
  end
end
