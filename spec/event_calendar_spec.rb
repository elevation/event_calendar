require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "event calendar" do
  it "should find the event model" do
    time  = DateTime.now 
    event = Event.new
    event.start_at = time
    event.end_at   = time
    event.start_at.should eql( time )
    event.end_at.should eql( time )
  end
end
