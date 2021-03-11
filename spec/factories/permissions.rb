FactoryBot.define do
  factory :permission do
    trait :create_review do
      name { 'can_create_review' }
    end
    trait :edit_review do
      name { 'can_edit_review' }
    end
    trait :delete_review do
      name { 'can_delete_review' }
    end
    trait :create_rating do
      name { 'can_create_rating' }
    end
    trait :edit_rating do
      name { 'can_edit_rating' }
    end
    trait :delete_rating do
      name { 'can_delete_rating' }
    end
  end
end
