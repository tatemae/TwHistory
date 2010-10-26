require File.expand_path("../../spec_helper", __FILE__)

describe Authentication do
  
  it { should belong_to :authenticatable }
  
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :name }
  it { should validate_presence_of :nickname }
  it { should validate_presence_of :token }
  it { should validate_presence_of :secret }
  
end