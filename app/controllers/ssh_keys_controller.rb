class SshKeysController < ApplicationController
  load_and_authorize_resource

  def index
    @ssh_keys = SshKey.all
  end

  def new
    @ssh_key = SshKey.new
    @users_for_select = User.for_select
  end

  def create
    @ssh_key = SshKey.new params[:ssh_key]
    if @ssh_key.save
      flash[:success] = "Added new ssh_key: #{ @ssh_key.name }"
      redirect_to ssh_keys_path
    else 
      @users_for_select = User.for_select
      render 'new'
    end
  end

#  def edit
#  end
#
#  def update
#  end

  def destroy
    @ssh_key.destroy
    flash[:success] = "Removed ssh_key: #{ @ssh_key.name }"
    redirect_to ssh_keys_path
  end

private 
  def find_ssh_key
    @ssh_key = SshKey.find_by_id(params[:id])
  end

end
