class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # sqlite3 db/development.sqlite3

  def show
    user = User.find_by_id(params[:user_id])
    if user != nil
      @posts = user.posts.all
      @rating = User.users_post_rating(current_user.id)
    else
      redirect_to '/', :flash => { :notice => "There is no such user !" }
    end
  end
end
