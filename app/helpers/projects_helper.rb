module ProjectsHelper
  
  def next_project_broadcast(project)
    if broadcast = project.next_broadcast
      %Q{<span class="next-broadcast"><strong>Next Broadcast:</strong>#{broadcast.by_start.to_s(:date_and_time)}</span>}
    end
  end

end
