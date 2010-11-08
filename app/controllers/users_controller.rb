# this is how admins interact with the user model
class UsersController < ApplicationController
  layout 'default'
  load_and_authorize_resource

  def index
  end

  def show
  end

  def servers
    # all servers and accounts @user is not on
    Account.not_for_user(@user).all.map {|acct|

    }
    render :json => @user.servers.map {|server| server.hostname}
  end

  def new
    @user = User.new
    @ssh_keys_for_select = SshKey.unclaimed.for_select
  end

  def create
    @user = User.new params[:user]
    # admin flag cannot be mass-assigned
    @user.admin = true if params[:user][:admin]
    if @user.save
      flash[:success] = "Successfully created new user."
      redirect_to users_path
    end
  end

  def edit
  end

  def update
  end
end
