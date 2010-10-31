class KeysController < ApplicationController
  before_filter :find_key, :only => [:edit, :update, :destroy]

  def index
    @keys = Key.all
  end

  def new
    @key = Key.new
    @users_for_select = User.for_select
  end

  def create
    @key = Key.new params[:key]
    if @key.save
      flash[:success] = "Added new key: #{ @key.name }"
      redirect_to keys_path
    else 
      @users_for_select = User.for_select
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @key.destroy
    flash[:success] = "Removed key: #{ @key.name }"
    redirect_to keys_path
  end

private 
  def find_key
    @key = Key.find_by_id(params[:id])
  end

end
