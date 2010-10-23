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
end
