module EventCalendar
  module Mongoid
    module ClassMethods
      # Override ActiveRecord version
      def events_for_date_range(start_d, end_d, find_options = {})
        # Merging find_options until https://github.com/mongoid/mongoid/issues/829 is fixed
        where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
                                 self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
      end
    end
  end
end

Mongoid::Document::ClassMethods.send :include, EventCalendar::ClassMethods
Mongoid::Document::ClassMethods.send :include, EventCalendar::Mongoid::ClassMethods