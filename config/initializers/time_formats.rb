# Custom time formats
{ :short_date => "%x", :long_date => "%a, %b %d, %Y", :just_time => "%I:%M%p" }.each do |k, v|
  Time::DATE_FORMATS[k] = v
end