FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    password { "password" }
    email { Faker::Internet.email }
    bio { Faker::Lorem.paragraph }

    trait :vinny do
      name "vinny"
      email "vinny@email.com"
      password "password"
      bio { Faker::Lorem.paragraph }
    end
  end
end
