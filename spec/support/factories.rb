FactoryGirl.define do

  factory :user do
    full_name 'Jared Haworth'
    nickname 'Jared'
    sequence(:email) { |n| "email#{n * Time.now.to_i}@example.com" }
    password 'test'
  end

end