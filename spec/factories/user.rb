FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@forsa.ie" }

    password { 'letmein' }
  end
end
