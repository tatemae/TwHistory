require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it { should have_many :projects }
  
end
