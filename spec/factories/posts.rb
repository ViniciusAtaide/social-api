FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph }
    likes { 0 }
    user
  end
end
