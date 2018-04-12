# coding: utf-8
require 'elasticsearch/model'

class Post < ApplicationRecord
  include Elasticsearch::Model
  include Swagger::Blocks

  swagger_schema :Post do
    key :required, [:content]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :content do
      key :description, 'Conteúdo do Post'
      key :type, :string
    end
  end

  validates :content, presence: true

  has_many :liked_posts
  has_many :comments, dependent: :destroy
  has_many :users, through: :liked_posts

  belongs_to :user
end
