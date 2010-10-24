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
  
end
