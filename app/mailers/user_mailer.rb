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
    mail(:to => @user.email, :subject => "Your Event Registration Confirmation")
  end

end
