class DefaultController < ApplicationController

  def index
    @project = Project.first # TODO make a 'featured project'
    @items = @project.items.by_newest.limit(4)
    respond_to do |format|
      format.html { render }
    end
  end

  def about
  end
  
  def search
    setup_will_paginate
    @search = ProjectSearch.new(@page, @per_page).search(params[:query])
    debugger
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
    BasicMailer.deliver_mail(:subject => I18n.t("contact.contact_response_subject", :application_name => MuckEngine.configuration.application_name), :body=>body.join("\n"))
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
