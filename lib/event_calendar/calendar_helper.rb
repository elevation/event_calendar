module EventCalendar
  module CalendarHelper
 
    # Returns an HTML calendar. In its simplest form, this method generates a plain
    # calendar (which can then be customized using CSS).
    # However, this may be customized in a variety of ways -- changing the default CSS
    # classes, generating the individual day entries yourself, and so on.
    #
    # The following are optional, available for customizing the default behaviour:
    # :month => Time.now.month # The month to show the calendar for. Defaults to current month.
    # :year => Time.now.year # The year to show the calendar for. Defaults to current year.
    # :table_class => "calendar" # The class for the <table> tag.
    # :month_name_class => "monthName" # The class for the name of the month, at the top of the table.
    # :other_month_class => "otherMonth" # Not implemented yet.
    # :day_name_class => "dayName" # The class is for the names of the weekdays, at the top.
    # :day_class => "day" # The class for the individual day number cells.
    # This may or may not be used if you specify a block (see below).
    # :abbrev => (0..2) # This option specifies how the day names should be abbreviated.
    # Use (0..2) for the first three letters, (0..0) for the first, and
    # (0..-1) for the entire name.
    # :first_day_of_week => 0 # Renders calendar starting on Sunday. Use 1 for Monday, and so on.
    # :accessible => true # Turns on accessibility mode. This suffixes dates within the
    # # calendar that are outside the range defined in the <caption> with
    # # <span class="hidden"> MonthName</span>
    # # Defaults to false.
    # # You'll need to define an appropriate style in order to make this disappear.
    # # Choose your own method of hiding content appropriately.
    #
    # :show_today => false # Highlights today on the calendar using the CSS class 'today'.
    # # Defaults to true.
    # :month_name_text => nil # Displayed center in header row. Defaults to current month name from Date::MONTHNAMES hash.
    # :previous_month_text => nil # Displayed left of the month name if set
    # :next_month_text => nil # Displayed right of the month name if set
    # :use_javascript => true # Outputs HTML with inline javascript so events spanning multiple days will be highlighted.
    # If this option is false, cleaner HTML will be output, but events spanning multiple days will 
    # not be highlighted correctly on hover, so it is only really useful if you know your calendar
    # will only have single-day events. Defaults to true.
    #
    # For more customization, you can pass a code block to this method, that will get one argument, a Date object,
    # and return a values for the individual table cells. The block can return an array, [cell_text, cell_attrs],
    # cell_text being the text that is displayed and cell_attrs a hash containing the attributes for the <td> tag
    # (this can be used to change the <td>'s class for customization with CSS).
    # This block can also return the cell_text only, in which case the <td>'s class defaults to the value given in
    # +:day_class+. If the block returns nil, the default options are used.
    #
    # Example usage:
    # calendar # This generates the simplest possible calendar with the curent month and year.
    # calendar({:year => 2005, :month => 6}) # This generates a calendar for June 2005.
    # calendar({:table_class => "calendar_helper"}) # This generates a calendar, as
    # # before, but the <table>'s class
    # # is set to "calendar_helper".
    # calendar(:abbrev => (0..-1)) # This generates a simple calendar but shows the
    # # entire day name ("Sunday", "Monday", etc.) instead
    # # of only the first three letters.
    # calendar do |d| # This generates a simple calendar, but gives special days
    # if listOfSpecialDays.include?(d) # (days that are in the array listOfSpecialDays) one CSS class,
    # [d.mday, {:class => "specialDay"}] # "specialDay", and gives the rest of the days another CSS class,
    # else # "normalDay". You can also use this highlight today differently
    # [d.mday, {:class => "normalDay"}] # from the rest of the days, etc.
    # end
    # end
    #
    # An additional 'weekend' class is applied to weekend days.
    #
    # For consistency with the themes provided in the calendar_styles generator, use "specialDay" as the CSS class for marked days.
    #
    def calendar(options = {}, &block)
      block ||= Proc.new {|d| nil}
 
      defaults = {
        :year => Time.zone.now.year,
        :month => Time.zone.now.month,
        :table_class => 'calendar',
        :month_name_class => 'monthName',
        :other_month_class => 'otherMonth',
        :day_name_class => 'dayName',
        :day_class => 'day',
        :abbrev => (0..2),
        :first_day_of_week => 0,
        :accessible => false,
        :show_today => true,
        :month_name_text => Time.zone.now.strftime("%B %Y"),
        :previous_month_text => nil,
        :next_month_text => nil,
        :start => nil,
        :event_strips => [],
        :event_width => 85,
        :event_height => 18,
        :min_height => 70,
        :event_margin => 2,
        :use_javascript => true,
        :link_to_day_action => false
      }
      options = defaults.merge options
    
      options[:month_name_text] ||= Date::MONTHNAMES[options[:month]]
 
      first = Date.civil(options[:year], options[:month], 1)
      last = Date.civil(options[:year], options[:month], -1)
    
      start = options[:start]
      event_strips = options[:event_strips]
      event_width = options[:event_width]
      event_height = options[:event_height]
      min_height = options[:min_height]
      event_margin = options[:event_margin]
 
      first_weekday = first_day_of_week(options[:first_day_of_week])
      last_weekday = last_day_of_week(options[:first_day_of_week])
    
      day_names = Date::DAYNAMES.dup
      first_weekday.times do
        day_names.push(day_names.shift)
      end
 
      # TODO Use some kind of builder instead of straight HTML
      cal = %(<table class="#{options[:table_class]}" width="#{event_width*7}" border="0" cellspacing="0" cellpadding="0">)
      cal << %(<thead><tr>)
      if options[:previous_month_text] or options[:next_month_text]
        cal << %(<th colspan="2">#{options[:previous_month_text]}</th>)
        colspan=3
      else
        colspan=7
      end
      cal << %(<th colspan="#{colspan}" class="#{options[:month_name_class]}">#{options[:month_name_text]}</th>)
      cal << %(<th colspan="2">#{options[:next_month_text]}</th>) if options[:next_month_text]
      cal << %(</tr><tr class="#{options[:day_name_class]}">)
      day_names.each do |d|
        unless d[options[:abbrev]].eql? d
          cal << %(<th scope="col"><span title="#{d}">#{d[options[:abbrev]]}</span></th>)
        else
          cal << %(<th scope="col">#{d[options[:abbrev]]}</th>)
        end
      end
      cal << "</tr></thead><tbody><tr>"
      #other month days, before current month
      beginning_of_week(first, first_weekday).upto(first - 1) do |d|
        cal << %(<td class="#{options[:other_month_class]})
        cal << " weekendDay" if weekend?(d)
        cal << " beginning_of_week" if d.wday == first_weekday
        if options[:accessible]
          cal << %(">#{d.day}<span class="hidden"> #{Date::MONTHNAMES[d.month]}</span></td>)
        else
          cal << %(">#{d.day}</td>)
        end
      end unless first.wday == first_weekday
    
      start_row = beginning_of_week(first, first_weekday)
      last_row = start_row
      first.upto(last) do |cur|
        cell_text, cell_attrs = nil#block.call(cur)
        cell_text ||= cur.mday
        cell_attrs ||= {:class => options[:day_class]}
        cell_attrs[:class] += " weekendDay" if [0, 6].include?(cur.wday)
        cell_attrs[:class] += " beginning_of_week" if cur.wday == first_weekday
        cell_attrs[:class] += " today" if (cur == Date.today) and options[:show_today]
        cell_attrs[:style] = "width:#{event_width-2}px;" # subtract 2 for the borders
        cell_attrs = cell_attrs.map {|k, v| %(#{k}="#{v}") }.join(" ")
        if options[:link_to_day_action]
          cal << "<td #{cell_attrs}>#{day_link(cell_text, cur, options[:link_to_day_action])}</td>"
        else 
          cal << "<td #{cell_attrs}>#{cell_text}</td>"
        end
      
        if cur.wday == last_weekday
          # calendar rows events
          content = calendar_row(event_strips,
                                 event_width,
                                 event_height,
                                 event_margin,
                                 start_row,
                                 last_row..cur,
                                 options[:use_javascript],
                                 &block)
          cal << "</tr>#{event_row(content, min_height, event_height, event_margin)}"
          cal << "<tr>" unless cur == last
          last_row = cur + 1
        end
      end
      # other month days, after current month, unless this month ended evenly on the last day of the week
      if last+1 != beginning_of_week(last+1, first_weekday)
        (last + 1).upto(beginning_of_week(last + 7, first_weekday) - 1) do |d|
          cal << %(<td class="#{options[:other_month_class]})
          cal << " weekendDay" if weekend?(d)
          cal << " beginning_of_week" if d.wday == first_weekday
          cal << %(" style="width:#{event_width-2}px;)
          if options[:accessible]
            cal << %(">#{d.day}<span class='hidden'> #{Date::MONTHNAMES[d.mon]}</span></td>)
          else
            cal << %(">#{d.day}</td>)
          end
        end unless last.wday == last_weekday
    
        # last calendar rows events
        content = calendar_row(event_strips,
                               event_width,
                               event_height,
                               event_margin,
                               start_row,
                               last_row..(beginning_of_week(last + 7, first_weekday) - 1),
                               options[:use_javascript],
                               &block)
        cal << "</tr>#{event_row(content, min_height, event_height, event_margin)}"
      end
      cal << "</tbody></table>"
    end
    
    def day_link(text, date, day_action)
      link_to(text, params.merge(:action => day_action, :day => date.day), :class => 'day_link')
    end
  
    private
  
    def calendar_row(event_strips, event_width, event_height, event_margin, start, date_range, use_javascript, &block)
      start_date = date_range.first
      range = ((date_range.first - start).to_i)...((date_range.last - start + 1).to_i)
      idx = -1
    
      #print "ROW: #{date_range} [#{start}] == #{range}\n"
  
      last_offs = 0
      event_strips.collect do |strip|
        idx += 1
        range.collect do |r|
          event = strip[r]
        
          if !event.nil?
            # Clip event dates (if it extends before or beyond the row)
            dates = event.clip_range(start_date, date_range.last)
            days_in_week = r-range.first
            if dates[0] - start_date == days_in_week
              # Event somewhere on this row
              # add 2 times the number of days into the week to account for borders
              cur_offs = (event_width*days_in_week) - 1
              event_content(event, dates[1]-dates[0]+1, cur_offs, idx, event_width, event_height, event_margin, use_javascript, &block)
            else
              nil
            end
          else
            nil
          end
        end.compact
      end
    end
  
    def event_row(content, min_height, event_height, event_margin)
      num_events = content.inject(0) do |sum, strip| 
        strip.blank? ? sum + 0 : sum + 1
      end
      event_height_total = (event_height+event_margin)*num_events + event_margin
      height = [min_height, event_height_total].max
      %(<tr><td colspan="7" class="event_row"><div class="events" style="height:#{height}px">#{content.join}</div><div class="clear"></div></td></tr>)
    end
  
    def event_content(event, days, cur_offs, idx, event_width, event_height, event_margin, use_javascript, &block)
      cal = ""

      cal << %(<div )
      cal << %(event_id="#{event.id}" day="#{event.start_at.day}" color="#{event.color}" ) if use_javascript
      cal << %(class="event event_#{event.id}" )
      cal << %(style="background-color: #{event.color}; width: #{event_width*days}px; height: #{event_height}px; top: #{idx*(event_height+event_margin)+event_margin}px; left:#{cur_offs}px;" )
      cal << %(onmouseover="select_event(this, true);" onmouseout="select_event(this, false);" ) if use_javascript
      cal << "> "
      cal << block.call(event)
      cal << "</div>"
      cal
    end
  
    def first_day_of_week(day)
      day
    end
  
    def last_day_of_week(day)
      if day > 0
        day - 1
      else
        6
      end
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
  
    def weekend?(date)
      [0, 6].include?(date.wday)
    end
  end
end
