FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph }
    likes { Faker::Number.number(2) }
    user
  end
end
