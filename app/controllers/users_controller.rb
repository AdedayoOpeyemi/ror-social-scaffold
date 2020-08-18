class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end

  def request_friendship
    @user = User.find(params[:id])

    current_user.request_friendship(@user) unless @user.nil? && @user != current_user

    redirect_back fallback_location: '/'
  end

  def friendship_requests
    # console
    @users = current_user.received_requests
  end

  def approve_request
    @user = User.find(params[:id])

    current_user.approve_requester(@user) unless @user.nil?

    redirect_back fallback_location: '/'
  end

  def decline_request
    @user = User.find(params[:id])

    current_user.decline_requester(@user) unless @user.nil?

    redirect_back fallback_location: '/'
  end
end
