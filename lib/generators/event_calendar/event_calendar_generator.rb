require 'rails/generators/migration'

class EventCalendarGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  class_option :static_only,       :type => :boolean, :default => false,       :desc => "Only generate stylesheets and scripts"
  class_option :use_jquery,        :type => :boolean, :default => false,       :desc => "Use JQuery for scripting"
  class_option :use_all_day,       :type => :boolean, :default => false,       :desc => "Add an additional all_day column to the database"
  class_option :model_name,        :type => :string,  :default => "event",     :desc => "Override the default model name"
  class_option :controller_name,   :type => :string,  :default => "calendars", :desc => "Override the controller and view name"
  
  def do_it
    copy_file "stylesheet.css", "public/stylesheets/event_calendar.css"    

    if options[:use_jquery]
      say "Using JQuery for scripting", :yellow
      copy_file 'jq_javascript.js', "public/javascripts/event_calendar.js"
    else
      say "Using Prototype for scripting", :yellow
      copy_file 'javascript.js', "public/javascripts/event_calendar.js"
    end

# TODO : why is this not working???? Predicates...

    unless options.static_only?
      template "model.rb.erb", "app/models/#{ model_name}.rb", :class_name => options[:model_name]
      template "controller.rb.erb", "app/controllers/#{ controller_name }_controller.rb"
      empty_directory "app/views/#{ view_name }"
      template "view.html.erb", File.join("app/views/#{ controller_name }/index.html.erb")
      template "helper.rb.erb", "app/helpers/#{ controller_name }_helper.rb"
      say "Adding an all_day column", :yellow if options[:use_all_day]
      migration_template "migration.rb.erb", "db/migrate/create_#{ table_name }.rb"
      route "match '#{ controller_name }(/:year(/:month))' => '#{ controller_name }#index', :as => :#{ controller_name }, :defaults => { :year => Time.zone.now.year, :month => Time.zone.now.month }"
    end

  end

  def model_class_name
    options[:model_name].classify
  end

  def model_name
    model_class_name.underscore
  end

  def view_name
    controller_name
  end

  def controller_class_name
    options[:controller_name].classify.pluralize
  end

  def controller_name
    controller_class_name.underscore
  end

  def helper_class_name
    controller_class_name
  end

  def table_name
    model_name.pluralize
  end

  # FIXME: Should be proxied to ActiveRecord::Generators::Base
  # Implement the required interface for Rails::Generators::Migration.
  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

end
