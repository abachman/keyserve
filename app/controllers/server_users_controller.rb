class ServerUsersController < ApplicationController
  load_and_authorize_resource

  def new
    @server_user = ServerUser.new
  end

  def create
    @server_user = ServerUser.new params[:server_user]
    if @server_user.save
      flash[:success] = "%s can access %s as %s" % [@server_user.user.name, 
                                                    @server_user.server.hostname,
                                                    @server_user.account.name]
      redirect_to root_path
    else
      render 'new'
    end
  end
end
