# coding: utf-8
require 'elasticsearch/model'

class User < ApplicationRecord
  include Swagger::Blocks
  include Elasticsearch::Model

  swagger_schema :User do
    key :required, [:name, :email, :password]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :email do
      key :type, :string
    end
    property :password do
      key :type, :string
    end
    property :bio do
      key :type, :string
    end
  end

  swagger_schema :UserInput do
    allOf do
      schema do
        key :'$ref', :User
      end
      schema do
        key :required, [:name, :email, :password]
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :name do
          key :description, 'Nome do Usuário'
          key :type, :string
        end
        property :email do
          key :description, 'Email do Usuário'
          key :type, :string
        end
        property :password do
          key :description, 'Senha do Usuário'
          key :type, :string
        end
      end
    end
  end

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :liked_posts
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :liked_comments

  has_many :posts, through: :liked_posts
  has_many :comments, through: :liked_comments
end
