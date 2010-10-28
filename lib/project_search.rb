class ProjectSearch
  attr_accessor :page, :per_page
  
  def initialize(page = 1, per_page = 30)
    @page = page
    @per_page = per_page
  end

  def search(search_for)
    Sunspot.search Project do
      keywords search_for
      paginate :page => page, :per_page => per_page
      order_by :score
    end
  end
  
end