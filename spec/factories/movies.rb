FactoryBot.define do
  factory :movie do
    title { Faker::Movie.title }
    description { 'Desciption of the movie' }
    release_date { '01-01-2021' }
    budget { 100000 }
    type { 'Movie' }
  end
end
