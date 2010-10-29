class AuthenticationsController < ApplicationController

  before_filter :store_parent, :only => [:new]
  before_filter :recover_parent, :only => [:create, :failure]

  def new
    if @parent.authentication
      flash[:notice] = translate('authentications.already_connected')
      redirect_to(@parent)
    else
      redirect_to "/auth/twitter"
    end
  end
  
  def create
    @omniauth = request.env["omniauth.auth"]
    if @parent.authentication
      flash[:notice] = translate('authentications.already_connected')
    else
      @authentication = @parent.build_authentication(:provider => @omniauth['provider'], 
                                     :uid => @omniauth['uid'],
                                     :name => @omniauth['user_info']['name'],
                                     :nickname => @omniauth['user_info']['nickname'],
                                     :token => @omniauth['credentials']['token'],
                                     :secret => @omniauth['credentials']['secret'])
      debugger
      if @authentication.save
        flash[:notice] = translate('authentications.connect_success')
      else
        flash[:notice] = translate('authentications.connect_error', :errors => @authentication.errors.full_messages.to_sentence)
      end
    end
    respond_to do |format|
      format.html { redirect_to([@parent.project, @parent]) }
    end
  end

  def failure
    flash[:notice] = translate('authentications.failure')
    respond_to do |format|
      format.html { redirect_to([@parent.project, @parent] }
    end
  end
  
  def destroy
    @authentication = Authentication.find(params[:id])
    @parent = @authentication.authenticatable
    @authentication.destroy
    respond_to do |format|
      format.html { redirect_to([@parent.project, @parent], :notice => translate('authentications.delete_success')) }
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
