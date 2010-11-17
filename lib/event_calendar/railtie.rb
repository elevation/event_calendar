require 'event_calendar'
require 'event_calendar/calendar_helper'
require 'rails'

module EventCalendar
  class Railtie < Rails::Engine
    initializer :after_initialize do
      ActionController::Base.helper EventCalendar::CalendarHelper
      ActiveRecord::Base.extend EventCalendar::ClassMethods
    end
  end
end
