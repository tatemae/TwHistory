class AuthenticationsController < ApplicationController

  before_filter :store_parent, :only => [:new]
  before_filter :recover_parent, :only => [:create, :failure]

  def new
    redirect_to "/auth/twitter"
  end
  
  def create
    @omniauth = request.env["omniauth.auth"]
    debugger
    if @parent.authentications.find_by_provider_and_uid(@omniauth['provider'], @omniauth['uid'])
      flash[:notice] = translate('authentications.already_connected')
    elsif @parent.authentications.create(:provider => @omniauth['provider'], 
                                         :uid => @omniauth['uid'],
                                         :name => @omniauth['user_info']['name'],
                                         :nickname => @omniauth['user_info']['nickname'],
                                         :token => @omniauth.token,
                                         :secret => @omniauth.secret)
      flash[:notice] = translate('authentications.connect_success')
    else
      flash[:notice] = translate('authentications.connect_error')
    end
    respond_to do |format|
      format.html { redirect_to(@parent) }
    end
  end

  def failure
    flash[:notice] = translate('authentications.failure')
    respond_to do |format|
      format.html { redirect_to(@parent) }
    end
  end
  
  def destroy
    @authentication = Authentication.find(params[:id])
    @parent = @authentication.authenticable
    @authentication.destroy
    respond_to do |format|
      format.html { redirect_to(@parent, :notice => translate('authentications.delete_success')) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def store_parent
      setup_parent
      session[:parent] = make_parent_params(@parent)
    end
    
    def recover_parent
      if session[:parent].any?
        klass = session[:parent][:parent_type].to_s.constantize
        @parent = klass.find(session[:parent][:parent_id])
        session[:parent] = nil
      end
      redirect_to(root_path, :notice => translate('authentications.no_parent_error')) unless @parent
    end
    
end
