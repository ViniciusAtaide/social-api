class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  def index
    page = params[:page] || 1
    posts = Post.paginate page: page
    render json: posts, status: :ok
  end

  def show
    render json: @post, status: :ok
  end

  def like
    liked_from = User.find params[:liked_from]
    post = Post.find params[:post_id]
    post.users<< liked_from
    render json: post.users, status: :ok
  end

  def unlike
    liked_from = User.find params[:liked_from]
    post = Post.find params[:post_id]
    post.users.destroy liked_from
    render json: post.users, status: :ok
  end

  def likes
    post = Post.find params[:post_id]
    render json: post.users.pluck(:id), status: :ok
  end

  def create
    user = User.find params[:user_id]
    post = Post.new post_params
    post.user = user
    post.save!
    render json: post, status: :ok
  end

  def update
    @user = AuthorizeApiRequest.call(request.headers).result

    if @user == @post.user
      @post.update post_params
      head :no_content
    else
      render json: 'Unauthorized', status: :unauthorized
    end
  end

  def destroy
    @user = AuthorizeApiRequest.call(request.headers).result

    if @user == @post.user
      @post.destroy
      head :no_content
    else
      render json: 'Unauthorized', status: :unauthorized
    end
  end

  private

  def post_params
    params.permit %i[content]
  end

  def set_post
    @post = Post.find params[:id]
  end
end
