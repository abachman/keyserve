class ServerUsersController < ApplicationController
  layout 'default'
  load_and_authorize_resource
  before_filter :load_selectors

  def new
    @server_user = ServerUser.new
  end

  def create
    @server_user = ServerUser.new params[:server_user]
    if @server_user.save
      flash[:success] = "%s will be able to access %s as %s" % [@server_user.user.email, 
                                                                @server_user.server.hostname,
                                                                @server_user.account.username]
      redirect_to root_path
    else
      render 'new'
    end
  end

  def load_selectors
    @users_for_select = User.for_select
    @servers_for_select = Server.for_select
    @accounts_for_select = []
  end
end
