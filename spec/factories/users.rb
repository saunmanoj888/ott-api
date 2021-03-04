FactoryBot.define do
  factory :user do
    email { "#{Faker::Name.first_name}@example.com" }
    password { 'password' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
