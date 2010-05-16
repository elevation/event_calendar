ActiveRecord::Base.send :include, EventCalendar
ActionView::Base.send   :include, EventCalendar::CalendarHelper
