class ApplicationController < ActionController::Base
  
  layout 'default'
    
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  protected
    
    # Used to get the project id and ensure the user has permission to modify it.
    def setup_project
      @project = Project.find(params[:project_id])
      if !@project.can_edit?(current_user)
        flash[:notice] = translate('projects.edit_permission_denied', :project_title => @project.title)
        redirect_to @project
      end
    end
    
end
