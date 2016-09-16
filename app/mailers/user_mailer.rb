class UserMailer < ActionMailer::Base
  default from: "elcommissioner@gmail.com"

  def password_reset_instructions(user)
    @user = user
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => @user.email, :subject => "Password Reset Instructions")
  end

  def user_message(user, sender, message_text)
    @user = user
    @sender = sender
    @message = message_text
    mail(:to => @user.email, :from => sender.email, :subject => "#{sender.full_name} has sent you a message via EasternLeague.net")
  end

  def membership_purchased(membership)
    @membership = membership
    @user = @membership.user
    mail(:to => @user.email, :subject => "Your Eastern League Membership Purchase")
  end

  def event_registration(event_registration)
    @event_registration = event_registration
    @user = @event_registration.competitor.user
    @event = @event_registration.event
    mail(:to => @user.email, :bcc => ["elcommissioner@gmail.com", @event.contact_email], :subject => "Your Event Registration Confirmation")
  end

  def time_to_renew(membership)
    @membership = membership
    @user = membership.user
    @commissioner = User.find(AdminSetting.first.commissioner_user_id)
    mail(:to => @user.email, :subject => "Your Eastern League Membership is about to Expire!")
  end

  def membership_expired(membership)
    @membership = membership
    @user = membership.user
    @commissioner = User.find(AdminSetting.first.commissioner_user_id)
    mail(:to => @user.email, :subject => "Your Eastern League Membership has Expired!")
  end

  def raffle_ticket_order(event, ticket_details)
    @event = event
    @details = ticket_details
    mail(:to => ["elcommissioner@gmail.com"], :subject => "Raffle Ticket Order")
  end

  def wildwood_registration(wildwood_registration)
    @event = Season.current.events.find_by_acronym("ECSKC")
    @wildwood_registration = wildwood_registration
    mail(:to => @wildwood_registration.email, :bcc => ["elcommissioner@gmail.com", @event.contact_email, "airguitar@comcast.net", "jackwilson@emtechva.com"], :subject => "Online Wildwood Registration Received")
    # mail(:to => @wildwood_registration.email, :bcc => ["elcommissioner@gmail.com"], :subject => "Online Wildwood Registration Received")
  end

end
