class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

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

  def comments
    user = User.find params[:user_id]
    render json: user.comments, status: :ok
  end

  swagger_controller :users, "Controle de Usuários"

  swagger_api :index do
    summary "Listagem de Usuários"
    param :query, :page, :integer, :optional, "Paginação"
    response :unauthorized
    response :not_acceptable, "A requisição feita não é aceitável."
  end

  swagger_api :show do
    summary "Usuário"
    response :unauthorized
    response :not_acceptable, "A requisição feita não é aceitável"
  end

  private

  def user_params
    params.permit %i[name email bio password]
  end

  def set_user
    @user = User.find params[:id]
  end

end
