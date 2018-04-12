class CommentSerializer < ActiveModel::Serializer
  attributes :content

  has_many :liked_comments
end
