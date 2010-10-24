require File.expand_path("../../spec_helper", __FILE__)

describe ApplicationHelper do
  
  describe "paging_information" do
    it "renders a string containing number of items" do
      @page = 1
      @per_page = 5
      start = 1
      last = 5
      items = 1...10.collect{|i| i}
      total = items.length
      helper.paging_information(items, total).should == "<strong>showing latest #{start}-#{last}</strong> of #{total}"
    end
    it "renders a string containing number of items even when @page is nil" do
      @page = nil
      @per_page = 5
      start = 1
      last = 5
      items = 1...10.collect{|i| i}
      total = items.length
      helper.paging_information(items, total).should == "<strong>showing latest #{start}-#{last}</strong> of #{total}"
    end
    it "renders a string containing number of items when paged" do
      @page = 2
      @per_page = 10
      start = 11
      last = 20
      items = 1...30.collect{|i| i}
      total = items.length
      helper.paging_information(items, total).should == "<strong>showing latest #{start}-#{last}</strong> of #{total}"
    end
    
  end
  
end