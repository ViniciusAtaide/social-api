require 'pry'

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
    liked_from = User.find params[:user_id]
    post = Post.find params[:post_id]
    binding.pry
    head :no_content
  end

  def create
    user = User.find params[:user_id]
    user.posts.create post_params
    render json: user.posts.last, status: :created
  end

  def update
    @post.update post_params
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
