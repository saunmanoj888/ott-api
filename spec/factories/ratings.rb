FactoryBot.define do
  factory :rating do
    value { 4 }
    user
    movie
  end
end
