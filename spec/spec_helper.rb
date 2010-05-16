ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + '/../../../..'
ENV["RAILS_ENV"]    = "test"

#require File.expand_path(File.dirname(ENV['RAILS_ROOT']) + "/config/environment")
require 'rubygems'
require 'spec'

require 'rails'
require 'active_record'

require 'spec/fixtures/models'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :events do |t|
    t.column :start_at, :datetime
    t.column :end_at,   :datetime
  end
end
