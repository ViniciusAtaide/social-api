FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    bio { Faker::Lorem.paragraph }

    trait :vinny do
      name "vinny"
      email "vinny@email.com"
    end
  end
end
