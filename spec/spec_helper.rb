ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + '/../../../..'
ENV["RAILS_ENV"]    = "test"

#require File.expand_path(File.dirname(ENV['RAILS_ROOT']) + "/config/environment")
require 'rubygems'
require 'spec'

require 'active_record'
require 'action_controller'
require 'action_view'


require 'event_calendar'
require 'event_calendar/calendar_helper'

require File.dirname(__FILE__) + '/../init.rb'
require 'spec/fixtures/models'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 0) do
  create_table :events do |t|
    t.column :start_at, :datetime
    t.column :end_at,   :datetime
  end
  create_table :custom_events do |t|
    t.column :custom_start_at, :datetime
    t.column :custom_end_at,   :datetime
  end
end
