# coding: utf-8
class CommentsController < ApplicationController
  include Swagger::Blocks
  before_action :set_comment, only: %i[show update destroy]

  swagger_path '/comments' do
    operation :get do
      key :name, 'Listagem de Comentários'
      key :operationId, 'index'
      key :produces, ['application/json']
      response 200 do
        key :description, 'Lista de Comentários'
        schema do
          key :type, :array
          items do
            key :'$ref', :Post
          end
        end
      end
      response :default do
        key :description, 'Erro na listagem'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
    operation :post do
      key :name, 'Criação de comentário'
      key :operationId, 'create'
      key :produces, ['application/json']
      parameter do
        key :'$ref', :PostInput
      end
    end
  end

  swagger_path '/comments/{id}' do
    operation :get do
      key :name, 'Comment'
      key :operationId, 'show'
      key :produces, ['application/json']
      parameter do
        key :type, :integer
      end
    end
    operation :patch do
      key :name, 'Atualizar Comentário'
      key :operationId, 'update'
      parameter do
        key :'$ref', :Comment
      end
    end
    operation :delete do
      key :name, 'Deletar Comentário'
      key :operationId, 'delete'
      parameter do
        key :name, :id
        key :type, :integer
      end
    end
  end

  swagger_path '/comments/{id}/likes' do
    operation :get do
      key :name, 'Likes'
      key :description, 'Lista todos os usuários que deram like no comentário'
      key :operationId, 'likes'
      key :produces, ['application/json']
      response 200 do
        key :description, 'Lista de likes do comentário'
        schema do
          key :type, :array
          items do
            key :type, :integer
          end
        end
      end
    end
  end

  swagger_path 'comments/{id}/like' do
    operation :post do
      key :name, 'Like'
      key :description, 'Dá like em um comentário'
      key :operationId, 'like'
      key :produces, ['application/json']
      response 200 do
        key :description, 'Likes do comentário'
        schema do
          key :type, :array
          items do
            key :'$ref', :User
          end
        end
      end
      response :default do
        key :description, 'Erro na Operação'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  swagger_path 'comments/{id}/unlike' do
    operation :post do
      key :name, 'Unlike'
      key :description, 'Dá unlike em um comentário'
      key :operationId, 'unlike'
      key :produces, ['application/json']
      response 200 do
        key :description, 'Likes do comentário'
        schema do
          key :type, :array
          items do
            key :'$ref', :User
          end
        end
      end
      response :default do
        key :description, 'Erro na Operação'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  def index
    page = params[:page] || 1
    comments = Comment.paginate page: page
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

  def likes
    comment = Comment.find params[:comment_id]
    render json: comment.users
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
    @user = AuthorizeApiRequest.call(request.headers).result

    if @comment.user = @user
      @comment.update comment_params
      head :no_content
    else
      render json: 'Unauthorized', status: :unauthorized
    end
  end

  def destroy
    @user = AuthorizeApiRequest.call(request.headers).result

    if @comment.user = @user
      @comment.destroy
      head :no_content
    else
      render json: 'Unauthorized', status: :unauthorized
    end
  end

  private

  def comment_params
    params.permit %i[content]
  end

  def set_comment
    @comment = Comment.find params[:id]
  end
end
