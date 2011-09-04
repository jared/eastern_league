FactoryGirl.define do

  factory :user do
    full_name 'Jared Haworth'
    nickname 'Jared'
    sequence(:email) { |n| "email#{n * Time.now.to_i}@example.com" }
    password 'test'
  end

  factory :membership_plan do
    name           '1 Year Individual'
    amount         15.00
    renewal_period 12
  end

  factory :membership do
    association :user
    association :membership_plan
    expires_at  1.year.from_now.end_of_month
    paid        true
  end

end