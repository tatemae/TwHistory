require "spec/spec_helper"

describe ProjectSearch do  
  
    before do
      @titanic_project = Factory.create(:project, :title => 'Titanic', :description => 'Sinking of the Titanic. Common.')
      @pioneer_project = Factory.create(:project, :title => 'Pioneer Trek', :description => 'The pioneer trek. Common')
      Sunspot.commit
    end

    describe "search" do
      it "finds matching projects" do
        ProjectSearch.new.search('Titanic').results.should include(@titanic_project)
        ProjectSearch.new.search('Common').results.should include(@titanic_project)
        ProjectSearch.new.search('Common').results.should include(@pioneer_project)
      end
      it "doesn't find non-matching projects" do
        ProjectSearch.new.search('Titanic').results.should_not include(@pioneer_project)
      end
    end
  
  
end
