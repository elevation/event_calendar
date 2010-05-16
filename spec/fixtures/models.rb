class CustomEvent < ActiveRecord::Base
  has_event_calendar :start_at_field => 'custom_start_at', :end_at_field => 'custom_end_at'
end

class Event < ActiveRecord::Base
end
