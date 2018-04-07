class ApplicationController < ActionController::API
  include ExceptionHandler
  include Swagger::Docs::ImpotentMethods

  attr_reader :current_user

  before_action :authenticate_request
  
  class << self
    Swagger::Docs::Generator::set_real_methods

    def inherited(subclass)
      super
      subclass.class_eval do
        setup_basic_api_documentation
      end
    end

    private
    def setup_basic_api_documentation
      [:index, :show, :create, :update, :delete].each do |action|
        swagger_api action do
          param :header, 'Authentication-Token', :string, required: 'Authentication token'
        end
      end
    end
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
