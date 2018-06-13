
# coding: utf-8
class PostsController < ApplicationController
  include Swagger::Blocks
  before_action :set_post, only: %i[show update destroy]

  swagger_path '/posts' do
    operation :get do
      key :name, 'Listagem de Posts'
      key :operationId, 'index'
      key :produces, [
            'application/json'
          ]
      response 200 do
        key :description, 'Lista de Posts'
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
      key :name, 'Criação de Post'
      key :operationId, 'create'
      key :produces, ['application/json']
      parameter do
        key :'$ref', :PostInput
      end
    end
  end

  swagger_path '/posts/{id}' do
    operation :get do
      key :name, 'Post'
      key :operationId, 'show'
      key :produces, ['application/json']
      parameter do
        key :type, :integer
      end
    end
    operation :patch do
      key :name, 'Atualizar Post'
      key :operationId, 'update'
      parameter do
        key :'$ref', :Post
      end
    end
    operation :delete do
      key :name, 'Deletar Post'
      key :operationId, 'delete'
      parameter do
        key :type, :integer
      end
    end
  end

  swagger_path '/posts/{id}/likes' do
    operation :get do
      key :name, 'Likes'
      key :description, 'Lista todos os usuários que deram like no post'
      key :operationId, 'likes'
      key :produces, ['application/json']
      response 200 do
        key :description, 'Lista de likes do post'
        schema do
          key :type, :array
          items do
            key :type, :integer
          end
        end
      end
    end
  end

  swagger_path 'posts/{id}/like' do
    operation :post do
      key :name, 'Like'
      key :description, 'Dá like em um post'
      key :operationId, 'like'
      key :produces, ['application/json']
      response 200 do
        key :description, 'Likes do post'
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
  swagger_path 'posts/{id}/unlike' do
    operation :post do
      key :name, 'Unlike'
      key :description, 'Dá unlike em um post'
      key :operationId, 'unlike'
      key :produces, ['application/json']
      response 200 do
        key :description, 'Likes do post'
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
    render json: post.users.pluck(:id), status: :ok
  end

  def unlike
    liked_from = User.find params[:liked_from]
    post = Post.find params[:post_id]
    post.users.destroy liked_from
    render json: post.users.pluck(:id), status: :ok
  end

  def likes
    post = Post.find params[:post_id]
    render json: post.users.pluck(:id), status: :ok
  end

  def create
    user = AuthorizeApiRequest.call(request.headers).result
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
