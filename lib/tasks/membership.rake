namespace :membership do
  desc "Find members expiring this month and notify them about renewal"
  task :send_renewal_notices => :environment do
    @memberships = Membership.find_due
    @memberships.each do |membership|
      UserMailer.time_to_renwe(membership).deliver
    end
  end
end