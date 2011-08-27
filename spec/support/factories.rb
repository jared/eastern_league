FactoryGirl.define do

  factory :user do
    first_name 'Jared'
    last_name 'Haworth'
    sequence(:email) { |n| "email#{n * Time.now.to_i}@example.com" }
    password 'test'
  end

end