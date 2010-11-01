class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def servers
    render :json => @user.servers.map {|server| server.hostname}
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
