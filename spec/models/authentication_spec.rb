require File.expand_path("../../spec_helper", __FILE__)

describe Authentication do
  
  it { should belong_to :authenticatable }
  
end