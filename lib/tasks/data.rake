require 'csv'

namespace :data do
  
  desc "Load Member Data from CSV file"
  task :member_load => :environment do
    arr_of_arrs = CSV.read("#{Rails.root}/tmp/tblMemberQueryText.csv")
    arr_of_arrs.each do |row|
       next if row[0] == "MemberID"
       u = User.new
       u.id = row[0]
       u.password = Time.now.to_i
       u.nickname = row[1]
       u.full_name = row[2]
       u.store_affiliation = row[4]
       u.street_address_1 = row[5]
       u.street_address_2 = row[6]
       u.city = row[7]
       u.state = row[8]
       u.zip = row[9]
       u.email = row[10].blank? ? "member#{row[0]}@example.com" : row[10]
       u.phone_number = row[11]
       u.el_member = row[12]
       u.board_member = row[13]
       u.lifetime = row[14]
       u.current_through_month = row[15]
       u.current_through_year = row[16]
       u.member_since = row[18].blank? ? nil : Time.parse(row[18])
       u.former_member = row[19]
       
       competitor = u.build_competitor
       competitor.id = row[0]

       if u.save
         if u.email =~ /example/
           puts "#{u.id} using temporary email, please resolve"
         end
       else
         puts "#{u.id}: #{u.errors.full_messages.to_sentence}"
       end
     end
    
  end
  
end