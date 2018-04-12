# coding: utf-8
class Comment < ApplicationRecord
  include Swagger::Blocks

  swagger_schema :Comment do
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

  has_many :liked_comments
  has_many :users, through: :liked_comments

  belongs_to :user
  belongs_to :post
end
