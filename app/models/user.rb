require 'elasticsearch/model'

class User < ApplicationRecord
    include Elasticsearch::Model

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy

    has_many :liked_posts, through: :liked_posts
end
