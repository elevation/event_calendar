ActiveRecord::Base.extend EventCalendar::PluginMethods
ActionView::Base.send :include, EventCalendar::CalendarHelper
