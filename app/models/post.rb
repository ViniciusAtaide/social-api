class Post < ApplicationRecord
  validates :content, presence: true

  has_many :liked_posts
  has_many :comments, dependent: :destroy
  has_many :users, through: :liked_posts

  belongs_to :user
end
