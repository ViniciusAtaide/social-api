# coding: utf-8
class UsersController < ApplicationController
  include Swagger::Blocks
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: %i[show update destroy]

  swagger_path '/users' do
    operation :get do
      key :name, 'Listagem de Usuários'
      key :operationId, 'index'
      key :produces, [
        'application/json'
      ]
      response 200 do
        key :description, 'Lista de Usuários'
        schema do
          key :type, :array
          items do
            key :'$ref', :User
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
      key :name, 'Criação de Usuário'
      key :operationId, 'create'
      key :produces, [
        'application/json'
      ]
      parameter do
        key :'$ref', :UserInput
      end
    end
  end

  swagger_path '/users/{id}' do
    operation :get do
      key :name, 'Usuário'
      key :operationId, 'show'
      key :produces, [
        'application/json'
      ]
      parameter do
        key :type, :integer
      end
    end
    operation :patch do
      key :name, 'Atualizar Usuário'
      key :operationId, 'update'
      parameter do
        key :'$ref', :UserInput
      end
    end
    operation :delete do
      key :name, 'Deletar Usuário'
      key :operationId, 'delete'
      parameter do
        key :type, :integer
      end
    end
  end

  swagger_path '/users/{id}/comments' do
    operation :get do
      key :name, 'Comentários'
      key :description, 'Mostra todos os comentários do usuário'
      key :operationId, 'comments'
      key :produces, [
            'application/json'
          ]
      response 200 do
        key :description, 'Lista de mensagens de usuário'
        schema do
          key :type, :array
          items do
            key :'$ref', :Comment
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
    users = User.paginate page: page
    render json: users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.create! user_params
    command = AuthenticateUser.call(user_params[:email], user_params[:password])
    render json: { auth_token: command.result }, status: :created
  end

  def update
    @user.update user_params
    head :no_content
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def comments
    user = User.find params[:user_id]
    render json: user.comments, status: :ok
  end

  private

  def user_params
    params.permit %i[name email bio password]
  end

  def set_user
    @user = User.find params[:id]
  end

end
