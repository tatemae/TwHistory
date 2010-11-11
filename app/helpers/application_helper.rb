module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  def just_date(date_time)
    return '' if date_time.blank?
    date_time.to_s(:short_date)
  end

  def just_time(date_time)
    return '' if date_time.blank?
    date_time.to_s(:just_time)
  end

  def location_link location
    ('<span class="location">' + link_to(location, location_path(location)) + '</span>') if !location.nil?
  end
  
  def paging_information(items, total)
    page = @page
    page ||= 1
    start = ((page - 1) * @per_page) + 1
    last = page * (items.length < @per_page ? items.length : @per_page)
    "<strong>showing latest #{start}-#{last}</strong> of #{total}"
  end
  
  def format_date_long(date)
    return '' if date.blank?
    date.to_s(:long_date)
  end
  
  def decades(start_decade, end_decade)
    decades = ''
		start_decade.step(end_decade, 10) {|i| decades << "<li>#{i}</li>" }
		decades.html_safe
	end

	def calculate_start_decade(featured_project_first_items)
	  return 1830 if featured_project_first_items.blank?
	  @start_decade ||= featured_project_first_items.collect{|item| decade_floor(item.event_date_time.to_s(:year).to_i)}.sort.first
  end
  
  # def calculate_end_decade(featured_project_first_items)
  #    return 1930 if featured_project_first_items.blank?
  #     @end_decade ||= featured_project_first_items.collect{|item| decade_round(item.event_date_time.to_s(:year).to_i)}.sort.last
  # end
  
  def calculate_step(start_year, end_year)
    (end_year - start_year)/10
  end
  
  def decade_floor(year)
    year - (year % 10)
  end
  
  def decade_round(year)
    year + (10 - (year % 10))
  end
  
  def calculate_end_decade(start_decade)
    start_decade + 100 # Output a 100 year span
  end
  
  def calculate_item_position(start_decade, item)
    step = 10
    item_year = item.event_date_time.to_s(:year).to_i
    distance = item_year - start_decade
    if distance <= step
      (distance * (95.0/step)).to_i
    else
      ((distance * (97.0/step))-2).to_i
    end
  end
  
  def calculate_indicator_position(item, featured_project_first_items)
    start_decade = calculate_start_decade(featured_project_first_items)
    item_position = calculate_item_position(start_decade, item)
    item_position - 60
  end
  
  def display_start_decade(start_decade)
    start_decade + 10 # The true start decade isn't show on the timeline so we offset to the next decade up.
  end
  
  def no_show
    if @time_for_now_show
      'featured-noshow'
    else
      @time_for_now_show = true
    end
  end
  
  
end
