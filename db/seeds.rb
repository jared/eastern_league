# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(id: 1, full_name: "Jared Haworth", nickname: "Jared", email: "jared@alloycode.com", password: "password1")

plans = MembershipPlan.create([{id: 1, name: '1 Year Individual', amount: 15.00, renewal_period: 12},
                               {id: 2, name: '1 Year Family', amount: 8.00, renewal_period: 12, primary: false},
                               {id: 3, name: '2 Year Individual', amount: 25.00, renewal_period: 24},
                               {id: 4, name: '2 Year Family', amount: 12.00, renewal_period: 24, primary: false},
                               {id: 5, name: 'Lifetime', amount: 0.00, renewal_period: 999, visible: false}])
