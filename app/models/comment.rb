class Comment < ApplicationRecord
  has_many :liked_comments
  has_many :users, through: :liked_comments

  belongs_to :user
  belongs_to :post
end
