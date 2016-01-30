class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # sqlite3 db/development.sqlite3

  def index
    @users = User.all
  end

  def show
    user = User.find_by_id(params[:user_id])
    if user != nil
      @posts = user.posts.all
      @rating = User.users_post_rating(user.id)
    else
      redirect_to '/', :flash => { :notice => "There is no such user !" }
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    if @user.destroy
        redirect_to '/users', notice: "User deleted."
    end    
  end

  def change_admin
    @user = User.find_by_id(params[:user_id])
    @user.update_attribute(:admin, not(@user.admin?))
    redirect_to '/users', notice: 'Status of user changed.'
  end
end
