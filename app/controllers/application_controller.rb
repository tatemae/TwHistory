class ApplicationController < ActionController::Base
  
  layout 'default'
    
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  protected
    
    def setup_will_paginate
      setup_paging
      set_will_paginate_string
    end
    
    # Used to get the project id and ensure the user has permission to modify it.
    def setup_project
      @project = Project.find(params[:project_id])
      if !@project.can_edit?(current_user)
        flash[:notice] = translate('general.inline_edit_permission_denied', :project_title => @project.title)
        redirect_to @project
      end
    end
    
    # Get's the project but doesn't redirect if the user doesn't have edit permission
    def setup_project_not_protected
      @project = Project.find(params[:project_id]) rescue nil
      @can_edit_project = false
      @can_edit_project = @project.can_edit?(current_user) if @project
    end
    
end
