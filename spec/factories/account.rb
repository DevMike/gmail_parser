FactoryBot.define do
  factory :account, class: Account do
    email Faker::Internet.email
  end
end
