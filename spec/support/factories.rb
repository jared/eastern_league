FactoryGirl.define do

  factory :user do
    full_name 'Jared Haworth'
    nickname 'Jared'
    sequence(:email) { |n| "email#{n * Time.now.to_i}@example.com" }
    password 'test'
  end
  
  factory :competitor do
    association :user
    bio "This is my competitor biography."
  end
  
  factory :pair, :parent => :competitor do
    pair true
    name "Dueling Sabers"
  end
  
  factory :team, :parent => :competitor do
    team true
    name "Rusty Sabers"
  end
  
  factory :team_member do
    association :competitor
    association :team
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
  
  factory :order do
    association :user
  end
  
  factory :line_item do
    association :order
    description "A Description"
    amount  15.00
  end

  factory :season do
    year        "2011"
    start_date  Date.new(2011, 8, 1)
    end_date    Date.new(2012, 7, 31)
    current     true
  end

  factory :event do
    name          "2011 Holly Springs Classic"
    acronym       "HSC"
    start_date    Date.new(2011, 8, 5)
    end_date      Date.new(2011, 8, 6)
    location      "Holly Springs, NC"
    contact_name  "Jared Haworth"
    contact_phone "123-345-5678"
    contact_email "hsc@example.com"
    url           "http://example.com"
    status        "Sanctioning Approved"
    fee_received  true
    association    :organizer
    association    :season
    registration_deadline Date.new(2011, 8, 1)
  end

end