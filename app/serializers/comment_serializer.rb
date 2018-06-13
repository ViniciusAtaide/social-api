class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content

  has_many :liked_comments
  belongs_to :user
end
