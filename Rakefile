require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name = "event_calendar"
    gem.summary = "Event Calendar"
    gem.email = "info@cyt.ch"
    gem.description = "Generates a calendar with events that span more than one day."
    gem.files = FileList["[A-Z]*", "{lib,rails}/**/*"]
    gem.authors = ["Jeff Schuil"]
    gem.homepage = "http://github.com/huerlisi/event_calendar"
    gem.require_path = 'lib'
    gem.files = %w(MIT-LICENSE CHANGELOG.rdoc README.rdoc Rakefile) + Dir.glob("{lib,generators,spec}/**/*")
    # Runtime dependencies: When installing event_calendar these will be checked if they are installed.
    # Will be offered to install these if they are not already installed.
    gem.add_dependency 'activerecord'
  end

  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or one of its dependencies is not installed."
end

task :default => :spec
desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
end

desc 'Generate documentation for the event_calendar plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'EventCalendar'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
