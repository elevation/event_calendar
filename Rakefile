require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "event-calendar"
    gem.summary = "Rails helper for showing multiple, overlapping events across calendar days and rows."
    gem.email = ""
    gem.description = "Rails helper for showing multiple, overlapping events across calendar days and rows."
    gem.authors = ["Jeff Schuil"]
    gem.homepage = "http://github.com/elevation/event_calendar"
    gem.require_path = 'lib'
    # Runtime dependencies
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  # Rspec 1.3
  require 'spec/rake/spectask'
  task :default => :spec
  desc "Run all specs"
  Spec::Rake::SpecTask.new do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--options', 'spec/spec.opts']
  end
  
rescue LoadError
  # RSpec 2
  require 'rspec/core/rake_task'
  task :default => :spec
  desc "Run all specs"
  RSpec::Core::RakeTask.new do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.rspec_opts = %w(-fs --color)
  end
  
rescue LoadError
  puts "Rspec not available. Install it with: gem install rspec"
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
