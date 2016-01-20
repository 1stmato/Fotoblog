class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # sqlite3 db/development.sqlite3

  def show
    @posts = current_user.posts.all
    @rating = User.users_post_rating(current_user.id)
  end
end
