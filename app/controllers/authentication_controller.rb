class AuthenticationController < ApplicationController
  include Swagger::Blocks
  skip_before_action :authenticate_request

  swagger_path '/authenticate' do
  	operation :post do
  		key :name, 'Autenticação'
  		key :description, 'Operação para se autenticar no sistema'
  		key :operationId, 'authenticate'
  		key :produces, [
  			'application/json'
  		]
  		parameter do
  			key :name, :name
  			key :in, :body
  			key :description, 'Nome do Usuário'
  			key :required, true
  			key :type, :string
  		end
  		parameter do
  			key :name, :password
  			key :in, :body
  			key :description, 'Senha do Usuário'
  			key :required, true
  			key :type, :string
  		end
  		response 200 do
  			key :description, 'Autenticado'
  			schema do
  				key :name, :token
  			end
  		end
  		response :default do
  			key :description, 'Erro na Autenticação'
  			schema do
 					key :'$ref', :ErrorModel 				
  			end
  		end
  	end
  end

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unautorized
    end
  end
end