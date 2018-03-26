FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph(2) }
    user
    post
  end
end
