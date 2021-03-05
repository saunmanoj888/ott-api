FactoryBot.define do
  factory :rating do
    value { 4 }
    user
    video { movie }
  end
end
