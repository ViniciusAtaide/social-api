FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph(2) }
    likes { Faker::Number.number }
    user { User.first }
    post { Post.first }
  end
end
