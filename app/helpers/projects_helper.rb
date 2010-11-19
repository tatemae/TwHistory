module ProjectsHelper
  
  def next_project_broadcast(project)
    if broadcast = project.next_broadcast
      %Q{<span class="next-broadcast"><a href="#{broadcast_path(broadcast)}"><strong>Next Broadcast:</strong>#{broadcast.start_at.to_s(:date_and_time)}</a>#{follow_link(project.next_broadcast)}</span>}
    else
      ''
    end
  end

  def follow_link(broadcast)
    if broadcast.authentication
      return link_to(translate('general.follow'), "http://twitter.com/#{broadcast.authentication.nickname}", :class => 'follow', :target => 'blank')
    end
  end
  
end
