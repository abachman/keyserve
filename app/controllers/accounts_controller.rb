class AccountsController < ApplicationController
  before_filter :load_server
  authorize_resource

  def index
    @excluding = User.find_by_id params[:exclude]
    @accounts = @server.accounts.select {|acc| !acc.users.include?(@excluding)} 
    respond_to do |format|
      format.html # default
      format.json { render :json => @accounts.map {|acc| [acc.username, acc.id]} }
    end
  end

  def new
    @account = Account.new :server_id => @server.id
  end

  def create
    @account = Account.new params[:account]
    @account.server = @server
    if @account.save
      flash[:success] = "Added #{ @account.username } to #{ @server.hostname }"
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

  def destroy
    @account.destroy
    flash[:success] = "Removed #{ @account.username } from #{ @server.name }"
    redirect_to server_accounts_path(@server)
  end

private
  def load_server
    @server = Server.find params[:server_id]
  end

end
