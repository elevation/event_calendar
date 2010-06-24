class EventCalendarGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  class_option :model_name, :desc => "Override the default model name ('event')", :type => :string, :default => "event"
  class_option :view_name, :desc => "Override the controller and view name ('calendar')", :type => :string, :default => "calendar"
  class_option :static_only, :desc => "Only generate stylesheets and scripts", :type => :boolean, :default => false
  class_option :use_jquery, :desc => "Use JQuery for scripting", :type => :boolean, :default  => false
  class_option :use_all_day, :desc => "Add an additional all_day column to the database", :type => :boolean, :default => false
  
  def manifest
    copy_file "stylesheet.css", "public/stylesheets/event_calendar.css"    

    if options.use_jquery?
      say "Using JQuery for scripting", :red
      copy_file 'jq_javascript.js', "public/javascripts/event_calendar.js"
    else
      say "Using Prototype for scripting", :red
      copy_file 'javascript.js', "public/javascripts/event_calendar.js"
    end

    unless options.static_only?
      template "model.rb.erb", "app/models/#{options[:model_name]}.rb"
      template "controller.rb.erb", "app/controllers/#{options[:view_name]}_controller.rb"
      directory File.join("app/views", options[:view_name])
      template "view.html.erb", File.join("app/views/#{options[:view_name]}/index.html.erb")
      template "helper.rb.erb", "app/helpers/#{options[:view_name]}_helper.rb"
      migration_template "migration.rb.erb", "db/migrate/create_#{options[:model_name].pluralize}.rb"
      route "match \'#{options[:view_name]}/:year/:month\' => \'#index', :as => :#{options[view_name]}, :defaults => { :year => Time.zone.now.year, :month => Time.zone.now.month }"
    end

  end

=begin
  def initialize(args, runtime_options = {})
    super
    usage if args.length > 0 and args.length < 2
    @class_name = (args.shift || "event").underscore
    @view_name = (args.shift || "calendar").underscore
  end
=end




end
