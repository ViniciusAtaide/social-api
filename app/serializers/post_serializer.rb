class PostSerializer < ActiveModel::Serializer
  attributes :id, :content

  has_many :comments
  belongs_to :user
  has_many :liked_posts
end