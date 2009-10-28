require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class EventCalendarGenerator < Rails::Generator::Base
  default_options :static_only => false
  
  attr_reader :class_name, :view_name
  
  def initialize(args, options = {})
    super
    usage if args.length > 0 and args.length < 2
    @class_name = (args.shift || "event").underscore
    @view_name = (args.shift || "calendar").underscore
  end
  
  def manifest
    record do |m|
      # static files
      m.file "stylesheet.css", "public/stylesheets/event_calendar.css"
      
			script = options[:use_jquery] ? 'jq_javascript.js' : 'javascript.js'
		  m.file script, "public/javascripts/event_calendar.js"
      
			m.directory "public/images/event_calendar"
      m.file "85_bg.gif", "public/images/event_calendar/85_bg.gif"
      m.file "120_bg.gif", "public/images/event_calendar/120_bg.gif"
      
      # MVC and other supporting files
      unless options[:static_only]
        m.template "model.rb.erb", File.join("app/models", "#{@class_name}.rb")
        m.template "controller.rb.erb", File.join("app/controllers", "#{@view_name}_controller.rb")
        m.directory File.join("app/views", @view_name)
        m.template "view.html.erb", File.join("app/views", @view_name, "index.html.erb")
        m.template "helper.rb.erb", File.join("app/helpers", "#{@view_name}_helper.rb")        
        m.migration_template "migration.rb.erb", "db/migrate", :migration_file_name => "create_#{@class_name.pluralize}"
        m.route_name(@view_name, "/#{@view_name}/:year/:month", ":controller => '#{@view_name}', :action => 'index', :year => Time.zone.now.year, :month => Time.zone.now.month")
      end
    end
  end
  
  protected
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--static-only",
      "Only generate the static files. (stylesheet, javascript, and images)") { |v| options[:static_only] = v }
    opt.on("--use-jquery",
      "Use jquery template file when generating the javascript.") { |v| options[:use_jquery] = v }
  end
end
