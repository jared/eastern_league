class UserMailer < ActionMailer::Base
  default from: "elcommissioner@gmail.com"

  def password_reset_instructions(user)
    @user = user
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => @user.email, :subject => "Password Reset Instructions")
  end
  
  def message(user, sender, message)
    @user = user
    @sender = sender
    @message = message
    mail(:to => @user.email, :from => sender.email, :subject => "#{sender.full_name} has sent you a message via EasternLeague.net")
  end

end
