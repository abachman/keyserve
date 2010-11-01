class AccountsController < ApplicationController
  before_filter :load_server
  authorize_resource

  def index
    @accounts = @server.accounts
  end

  def new
    @account = Account.new :server_id => @server.id
  end

  def create
    @account = Account.new params[:account]
    @account.server = @server
    if @account.save
      flash[:success] = "Added new #{ @account.name } to #{ @server.hostname }"
      redirect_to server_accounts_path(@server)
    else
      @ssh_keys_for_select = SshKey.for_select
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @account.destroy
    flash[:success] = "Removed #{ @account.name } from #{ @server.name }"
    redirect_to server_accounts_path(@server)
  end

private
  def load_server
    @server = Server.find params[:server_id]
  end

end
