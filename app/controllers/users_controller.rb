class UsersController < ApplicationController
  before_action :authenticate_user!, only:[:index]
  before_action :set_user, only: [:show]
  before_action :count_friend_elements, only:[:index]

  def index
    case params[:people] when "friends"
      @users = current_user.active_friends
    when "requests"
      @users = current_user.pending_friend_requests_from.map(&:user)
    when "pending"
      @users = current_user.pending_friend_requests_to.map(&:friend)
    else
      @users = User.where.not(id: current_user.id)
    end
  end

  def show
    @post = Post.new
    @posts = @user.posts
    @activities = PublicActivity::Activity.where(owner_id: @user.id) + PublicActivity::Activity.where(recipient_id: @user.id)
  end

  private

  def set_user
    @user = User.find_by(username: params[:id])
  end

  def count_friend_elements
    @friend_count = current_user.active_friends.count
    @request_count = current_user.pending_friend_requests_from.map(&:user).count
    @pending_count = current_user.pending_friend_requests_to.map(&:friend).count
  end
end
