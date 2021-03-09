FactoryBot.define do
  factory :review do
    body { 'Nice Movie' }
    user
    movie
  end
end
