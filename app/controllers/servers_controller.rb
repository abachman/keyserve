class ServersController < ApplicationController
  layout 'default'
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # normal
      format.json { render :json => Server.for_select }
    end
  end

  def new
    @server = Server.new
    @ssh_keys_for_select = SshKey.for_select
  end

  def create
    @server = Server.new params[:server]
    if @server.save
      flash[:success] = "Added new server: #{ @server.hostname }"
      redirect_to servers_path
    else
      @ssh_keys_for_select = SshKey.for_select
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def new_user
  end

  def add_user
  end

  def destroy
    @server.destroy
    flash[:success] = "Removed server: #{ @server.name }"
    redirect_to servers_path
  end

end
