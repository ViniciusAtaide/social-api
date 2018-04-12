class PostSerializer < ActiveModel::Serializer
  attributes :content

  has_many :comments
  belongs_to :user
end