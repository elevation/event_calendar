require 'rails/generators/migration'

class EventCalendarGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  argument :model_name, :optional => true, :default => 'event'
  argument :controller_name, :optional => true, :default => 'calendar'
  
  class_option :static_only,  :type => :boolean, :default => false, :desc => "Only generate stylesheets and scripts"
  { 'jquery' => 'jQuery', 'mootools' => 'MooTools' }.each do |k,v|
    class_option :"use_#{k}",   :type => :boolean, :default => false, :desc => "Use #{v} for scripting"  
  end
  class_option :use_all_day,  :type => :boolean, :default => false, :desc => "Add an additional 'all_day' attribute"
  class_option :use_color,    :type => :boolean, :default => false, :desc => "Add an additional 'color' attribute"
  
  def do_it
    say "Adding an all_day column", :yellow if options[:use_all_day]
    say "Adding a color column", :yellow if options[:use_color]

    if options[:use_jquery]
      say "Using jQuery for scripting", :yellow
      copy_file 'jq_javascript.js', "public/javascripts/event_calendar.js"
    elsif options[:use_mootools]
      say "Using MooTools for scripting", :yellow
      copy_file "mt_javascript.js", "public/javascripts/event_calendar.js"
    else
      say "Using Prototype for scripting", :yellow
      copy_file 'javascript.js', "public/javascripts/event_calendar.js"
    end

    copy_file "stylesheet.css", "public/stylesheets/event_calendar.css"

    unless options.static_only?
      template "model.rb.erb", "app/models/#{model_name}.rb"
      template "controller.rb.erb", "app/controllers/#{controller_name}.rb"
      empty_directory "app/views/#{view_name}"
      template "view.html.erb", File.join("app/views/#{view_name}/index.html.erb")
      template "helper.rb.erb", "app/helpers/#{helper_name}.rb"
      migration_template "migration.rb.erb", "db/migrate/create_#{table_name}.rb"
      route "match '/#{view_name}(/:year(/:month))' => '#{view_name}#index', :as => :#{named_route_name}, :constraints => {:year => /\\d{4}/, :month => /\\d{1,2}/}"
    end

  end

  def model_class_name
    @model_name.classify
  end

  def model_name
    model_class_name.underscore
  end

  def view_name
    @controller_name.underscore
  end

  def controller_class_name
    "#{@controller_name}_controller".classify
  end

  def controller_name
    controller_class_name.underscore
  end

  def helper_class_name
    "#{@controller_name}_helper".classify
  end
  
  def helper_name
    helper_class_name.underscore
  end

  def table_name
    model_name.pluralize
  end

  def named_route_name
    if view_name.include?("/")
      view_name.split("/").join("_")
    else
      view_name
    end
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
