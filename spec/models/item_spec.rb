require File.dirname(__FILE__) + '/../spec_helper'

describe Item do
  
  it { should belong_to :project }
  it { should belong_to :character }
  
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
  
  it { should_not allow_mass_assignment_of :lat }
  it { should_not allow_mass_assignment_of :lng }
  it { should_not allow_mass_assignment_of :created_at }
  it { should_not allow_mass_assignment_of :updated_at }
  
  it { should validate_presence_of :content }
  it { should validate_presence_of :event_date_time }
  
end
