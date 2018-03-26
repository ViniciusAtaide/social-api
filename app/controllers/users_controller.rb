class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    @user = User.find user_params :id
    render json: @user, status: :ok
  end

  def create
    @user = User.create! user_params
    render json: @user, status: :created
  end

  def update
    @user.update user_params
    head :no_content
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def user_params
    params.permit %i[name email]
  end

  def set_user
    @user = User.find params[:id]
  end
end
