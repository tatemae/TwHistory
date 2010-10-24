class AuthenticationsController < ApplicationController

  before_filter :setup_parent
  
  def index
    @authentications = @parent.authentications
    respond_to do |format|
      format.html
      format.xml  { render :xml => @authentications }
    end
  end

  def create
    @omniauth = request.env["omniauth.auth"]
    debugger
    if @parent.authentications.find_by_provider_and_uid(@omniauth['provider'], @omniauth['uid'])
      flash[:notice] = "You've already connected to this Twitter account."
    elsif @parent.authentications.create(:provider => @omniauth['provider'], :uid => @omniauth['uid'], :raw_auth => @omniauth.to_json)
      flash[:notice] = 'You successfully connected to the Twitter account.'
    else
      flash[:notice] = 'Could not connect to Twitter account. Please try again.'
    end
    respond_to do |format|
      format.html { redirect_to(polymorhpic_path([@parent, :authentications])) }
    end
  end

  def failure
    flash[:notice] = 'Could not connect to Twitter account. Please try again.'
    debugger
    respond_to do |format|
      format.html { redirect_to(polymorhpic_path([@parent, :authentications])) }
    end
  end
  
  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    respond_to do |format|
      format.html { redirect_to(authentications_url) }
      format.xml  { head :ok }
    end
  end
  
end
