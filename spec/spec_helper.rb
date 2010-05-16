ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + '/../../../..'
ENV["RAILS_ENV"]    = "test"

#require File.expand_path(File.dirname(ENV['RAILS_ROOT']) + "/config/environment")
require 'rubygems'
require 'spec'

require 'rails'
require 'active_record'
require 'action_controller'
require 'action_view'

require 'spec/fixtures/models'

require 'event_calendar'
require 'event_calendar/calendar_helper'

require File.dirname(__FILE__) + '/../init.rb'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :events do |t|
    t.column :start_at, :datetime
    t.column :end_at,   :datetime
  end
end
