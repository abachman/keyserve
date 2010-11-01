class ServerUsersController < ApplicationController
  layout 'default'
  load_and_authorize_resource

  def new
    @server_user = ServerUser.new
    @users_for_select = User.for_select
    @servers_for_select = []
    @accounts_for_select = []
  end

  def create
    @server_user = ServerUser.new params[:server_user]
    @server_user.ssh_key = @server_user.user.ssh_keys.first
    if @server_user.save
      flash[:success] = "%s will be able to access %s as %s" % [@server_user.user.email, 
                                                                @server_user.server.hostname,
                                                                @server_user.account.name]
      redirect_to root_path
    else
      render 'new'
    end
  end
end
