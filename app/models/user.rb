require 'elasticsearch/model'

class User < ApplicationRecord    
  include Elasticsearch::Model

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
