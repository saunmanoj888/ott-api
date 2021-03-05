FactoryBot.define do
  factory :review do
    body { 'Nice Movie' }
    user
    video { movie }
  end
end
