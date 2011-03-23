class DefaultController < ApplicationController

  def index
    @custom_timeline = true
    @featured_projects = Project.featured.by_featured.limit(6)
    @featured_project_first_items = []
    @featured_project_items = {}
    @featured_projects.each do |project|
      @featured_project_items[project.id] = project.items.by_event_date_time.limit(4)
      @featured_project_first_items << @featured_project_items[project.id].first
    end
    respond_to do |format|
      format.html { render }
    end
  end

  def about
  end
  
  def teachers
  end
  
  def search
    setup_will_paginate
    @search = ProjectSearch.new(@page, @per_page).search(params[:query])
    @total_count = @search.total
    @projects = @search.results
  end
  
  def contact
    return unless request.post?
    body = []
    params.each_pair do |k,v|
      if !['authenticity_token', 'action', 'controller'].include?(k) 
        body << "#{k}: #{v}"
      end
    end
    BasicMailer.mail_from_params(:subject => I18n.t("contact.contact_response_subject", :application_name => MuckEngine.configuration.application_name), :body=>body.join("\n")).deliver
    flash[:notice] = I18n.t('general.thank_you_contact')
    redirect_to contact_url    
  end

  def sitemap
    respond_to do |format|
      format.html { render }
    end
  end

  def ping
    user = User.first
    render :text => 'we are up'
  end
  
end
