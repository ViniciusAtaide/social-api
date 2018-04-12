class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Social Api'
    end
    key :consumes, ['application/json']
    key :produces, ['application/json']

    security_definition :api_key do
      key :type, :apiKey
      key :name, :authorization
      key :in, :header
    end
  end
  CLASS_LIST = [
    AuthenticationController,
    UsersController,
    User,
    Post,
    Comment,
    ErrorModel,
    PostsController,
    CommentsController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(CLASS_LIST)
  end

end
