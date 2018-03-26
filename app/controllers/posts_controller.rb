class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  def index
    posts = Post.all
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

  def create
    user = User.find params[:user_id]
    user.posts.create post_params
    render json: user.posts.last, status: :ok
  end

  def update
    @post.update post_params
    head :no_content
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def post_params
    params.permit %i[content]
  end

  def set_post
    @post = Post.find params[:id]
  end
end
