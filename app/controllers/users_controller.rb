class UsersController < ApplicationController
  layout 'default'
  load_and_authorize_resource

  def index
  end

  def new
  end

  def servers
    # all servers and accounts @user is not on
    Account.not_for_user(@user).all.map {|acct|

    }
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
