class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show update destroy]

  def index
    comments = Comment.all
    render json: comments, status: :ok
  end

  def show
    render json: @comment, status: :ok
  end

  def like
    liked_from = User.find params[:liked_from]
    comment = Comment.find params[:comment_id]
    comment.users<< liked_from
    render json: comment.users, status: :ok
  end

  def unlike
    liked_from = User.find params[:liked_from]
    comment = Comment.find params[:comment_id]
    comment.users.destroy liked_from
    render json: comment.users, status: :ok
  end

  def create
    user = User.find params[:user_id]
    post = Post.find params[:post_id]
    comment = Comment.new comment_params
    comment.user = user
    comment.post = post
    comment.save!
    render json: comment, status: :ok
  end

  def update
    @comment.update comment_params
    head :no_content
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def comment_params
    params.permit %i[content]
  end

  def set_comment
    @comment = Comment.find params[:id]
  end
end
