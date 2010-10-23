class AuthenticationsController < ApplicationController

  def index
    @authentications = Authentication.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authentications }
    end
  end

  def show
    @authentication = Authentication.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @authentication }
    end
  end

  def new
    @authentication = Authentication.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @authentication }
    end
  end

  def edit
    @authentication = Authentication.find(params[:id])
  end

  def create
    @authentication = Authentication.new(params[:authentication])
    respond_to do |format|
      if @authentication.save
        format.html { redirect_to(@authentication, :notice => 'Authentication was successfully created.') }
        format.xml  { render :xml => @authentication, :status => :created, :location => @authentication }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @authentication.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @authentication = Authentication.find(params[:id])
    respond_to do |format|
      if @authentication.update_attributes(params[:authentication])
        format.html { redirect_to(@authentication, :notice => 'Authentication was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @authentication.errors, :status => :unprocessable_entity }
      end
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
