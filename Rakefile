require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "event-calendar"
    gem.summary = "Rails helper for generating a calendar of events."
    gem.email = ""
    gem.description = "Rails helper for generating a calendar of events. These events can optionally span multiple days."
    gem.authors = ["Jeff Schuil"]
    gem.homepage = "http://github.com/elevation/event_calendar"
    gem.require_path = 'lib'
    # Runtime dependencies
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
task :default => :spec
desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
end

require 'rake/rdoctask'
desc 'Generate documentation for the event_calendar plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'EventCalendar'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
