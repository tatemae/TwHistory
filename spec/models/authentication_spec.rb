require File.dirname(__FILE__) + '/../spec_helper'

describe Authentication do
  
  it { should belong_to :authenticatable }
  
end