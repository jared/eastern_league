namespace :membership do
  desc "Find members expiring this month and notify them about renewal"
  task :send_renewal_notices => :environment do
    @memberships = Membership.find_due
    @memberships.each do |membership|
      if membership.user.temporary_email?
        admin = User.find(AdminSetting.first.commissioner_user_id)
        UserMailer.user_message(admin,admin,"Could not email renewal information to #{membership.user.id}: #{membership.user.full_name} -- no email on file.").deliver
      else
        UserMailer.time_to_renew(membership).deliver
      end
    end
  end
end