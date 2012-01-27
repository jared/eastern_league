FactoryGirl.define do

  factory :user do
    full_name 'Jared Haworth'
    nickname 'Jared'
    sequence(:email) { |n| "email#{n * Time.now.to_i}@example.com" }
    password 'test'
  end
  
  factory :active_user, :parent => :user do
    el_member true
    current_through_date 6.months.from_now.to_date
  end
  
  factory :expired_user, :parent => :user do
    el_member true
    current_through_date 1.month.ago.to_date
  end
  
  factory :expiring_soon_user, :parent => :user do
    el_member true
    current_through_date 15.days.from_now.to_date
  end
  
  factory :board_member_user, :parent => :user do
    el_member true
    board_member true
  end
  
  factory :lifetime_member_user, :parent => :user do
    el_member true
    lifetime true
  end
  
  factory :competitor do
    association :user, :factory => :active_user
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
    year        "2012"
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
    association    :organizer, :factory => :active_user
    association    :season
    registration_deadline Date.new(2011, 8, 1)
  end
  
  factory :event_discipline do
    association :event
    association :discipline
  end
  
  factory :event_detail do
    association :event
    general_information "Some general event info"
  end

  factory :discipline do
    name          "Masters Individual Ballet"
    abbreviation  "MIB"
  end
  
  factory :score do
    association :season
    association :competitor
    association :event_discipline
    disqualified false    
  end

  factory :standing do
    association :competitor
    association :discipline
    competition_count 1
    points            26
    rank              1
  end

end