class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy like]

  def index
    @posts = Post.all
    render json: @posts, status: :ok
  end

  def show
    render json: @post, status: :ok
  end

  def like
    @post.update @post.likes + 1
    head :no_content
  end

  private

  def post_params
    params.permit %i[content likes]
  end

  def set_post
    @post = Post.find params[:id]
  end
end
