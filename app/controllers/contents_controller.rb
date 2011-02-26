class ContentsController < Muck::ContentsController
  before_filter :turn_off_sidebar
  
  protected
    def turn_off_sidebar
      @sidebar_off = true
    end
  
end
