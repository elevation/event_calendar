module EventCalendar
  
  module PluginMethods
    def has_event_calendar
      ClassMethods.setup_event_calendar_on self
    end
  end
  
  # class Methods
  module ClassMethods
    
    def self.setup_event_calendar_on(recipient)
      recipient.extend ClassMethods
      recipient.class_eval do
        include InstanceMethods
      end
    end
    
    # For the given month, find the start and end dates
    # Find all the events within this range, and create event strips for them
    def event_strips_for_month(shown_date, first_day_of_week=0)
      strip_start, strip_end = get_start_and_end_dates(shown_date, first_day_of_week)
      events = events_for_date_range(strip_start, strip_end)
      event_strips = create_event_strips(strip_start, strip_end, events)
      event_strips
    end
    
    # Expand start and end dates to show the previous month and next month's days,
    # that overlap with the shown months display
    def get_start_and_end_dates(shown_date, first_day_of_week=0)
      # start with the first day of the given month
      start_of_month = Date.civil(shown_date.year, shown_date.month, 1)
      # the end of last month
      strip_start = beginning_of_week(start_of_month, first_day_of_week)
      # the beginning of next month, unless this month ended evenly on the last day of the week
      if start_of_month.next_month == beginning_of_week(start_of_month.next_month, first_day_of_week)
        # last day of the month is also the last day of the week
        strip_end = start_of_month.next_month
      else
        # add the extra days from next month
        strip_end = beginning_of_week(start_of_month.next_month + 7, first_day_of_week)
      end
      [strip_start, strip_end]
    end
    
    # Get the events overlapping the given start and end dates
    def events_for_date_range(start_d, end_d)
      self.find(
        :all,
        :conditions => [ '(? <= end_at) AND (start_at < ?)', start_d.to_time.utc, end_d.to_time.utc ],
        :order => 'start_at ASC'
      )
    end
    
    # Create the various strips that show evetns
    def create_event_strips(strip_start, strip_end, events)
      # create an inital event strip, with a nil entry for every day of the displayed days
      event_strips = [[nil] * (strip_end - strip_start + 1)]
    
      events.each do |event|
        cur_date = event.start_at.to_date
        end_date = event.end_at.to_date
        cur_date, end_date = event.clip_range(strip_start, strip_end)
        start_range = (cur_date - strip_start).to_i
        end_range = (end_date - strip_start).to_i
      
        # make sure the event is within our viewing range
        if (start_range <= end_range) and (end_range >= 0) 
          range = start_range..end_range
          
          open_strip = space_in_current_strips?(event_strips, range)
          
          if open_strip.nil?
            # no strips open, make a new one
            new_strip = [nil] * (strip_end - strip_start + 1)
            range.each {|r| new_strip[r] = event}
            event_strips << new_strip
          else
            # found an open strip, add this event to it
            range.each {|r| open_strip[r] = event}
          end
        end
      end
      event_strips
    end
    
    def space_in_current_strips?(event_strips, range)
      open_strip = nil
      for strip in event_strips
        strip_is_open = true
        range.each do |r|
          # overlapping events on this strip
          if !strip[r].nil?
            strip_is_open = false
            break
          end
        end

        if strip_is_open
          open_strip = strip
          break
        end
      end
      open_strip
    end
    
    def days_between(first, second)
      if first > second
        second + (7 - first)
      else
        second - first
      end
    end

    def beginning_of_week(date, start = 0)
      days_to_beg = days_between(start, date.wday)
      date - days_to_beg
    end
    
  end
  
  # Instance Methods
  # Override in your model as needed
  module InstanceMethods
    def year
      date.year
    end
  
    def month
      date.month
    end
 
    def day
      date.day
    end
    
    def all_day
      self[:all_day]
    end
    
    def color
      self[:color] || '#9aa4ad'
    end
  
    def days
      end_at.to_date - start_at.to_date
    end
  
    # start_d - start of the month, or start of the week
    # end_d - end of the month, or end of the week
    def clip_range(start_d, end_d)
      # make sure we are comparing date objects to date objects,
      # otherwise timezones can cause problems
      start_at_d = start_at.to_date
      end_at_d = end_at.to_date
      # Clip start date, make sure it also ends on or after the start range
      if (start_at_d < start_d and end_at_d >= start_d)
        clipped_start = start_d
      else
        clipped_start = start_at_d
      end
    
      # Clip end date
      if (end_at_d > end_d)
        clipped_end = end_d
      else
        clipped_end = end_at_d
      end
      [clipped_start, clipped_end]
    end
  end
end