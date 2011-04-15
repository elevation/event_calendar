require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class EventCalendarGenerator < Rails::Generator::Base
  default_options :static_only => false,
                  :use_jquery =>  false,
                  :use_all_day => false,
                  :use_mootools => false
  
  attr_reader :class_name, :view_name
  
  def initialize(args, runtime_options = {})
    super
    usage if args.length > 0 and args.length < 2
    @class_name = (args.shift || "event").underscore
    @view_name = (args.shift || "calendar").underscore
  end
  
  def manifest
    record do |m|
      # static files
      m.file "stylesheet.css", "public/stylesheets/event_calendar.css"
      
      script = options[:use_jquery] ? 'jq_javascript.js' : (options[:use_mootools] ? 'mt_javascript.js' : 'javascript.js')
      m.file script, "public/javascripts/event_calendar.js"
      
      # MVC and other supporting files
      unless options[:static_only]
        m.template "model.rb.erb", File.join("app/models", "#{@class_name}.rb")
        m.template "controller.rb.erb", File.join("app/controllers", "#{@view_name}_controller.rb")
        m.directory File.join("app/views", @view_name)
        m.template "view.html.erb", File.join("app/views", @view_name, "index.html.erb")
        m.template "helper.rb.erb", File.join("app/helpers", "#{@view_name}_helper.rb")        
        m.migration_template "migration.rb.erb", "db/migrate", :migration_file_name => "create_#{@class_name.pluralize}"
        m.route_name(@view_name, "/#{@view_name}/:year/:month", ":controller => '#{@view_name}', :action => 'index', :requirements => {:year => /\\d{4}/, :month => /\\d{1,2}/}, :year => nil, :month => nil")
      end
    end
  end
  
  protected
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--static-only",
      "Only generate the static files. (stylesheet, javascript, and images)") { |v| options[:static_only] = v }
    { 'jquery' => 'jQuery', 'mootools' => 'MooTools' }.each do |k,v|
      opt.on("--use-#{k}",
        "Use #{v} template file when generating the javascript.") { |val| options[:"use_#{v}"] = val }    
    end
    opt.on("--use-all-day",
      "Include an 'all_day' field on events, and display appropriately.") { |v| options[:use_all_day] = v }
  end
end
