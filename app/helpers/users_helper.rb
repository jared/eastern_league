module UsersHelper
  
  def membership_status_display(user)
    case user.membership_status
    when "active"
      message = "Your Eastern League membership is in good standing.  Your membership is valid through #{l(user.current_through_date, :format => :membership_date)}."
      class_name = "alert_info"
    when "expired"
      message = "Your Eastern League Membership has expired.  Your expiration date was #{l(user.current_through_date, :format => :membership_date)}.  #{link_to("Renew Eastern League Membership", new_user_membership_path(user))}"
      class_name = "alert_error"
    when "expiring_soon"
      message = "Your Eastern League Membership will soon expire.  Your expiration date is #{l(user.current_through_date, :format => :membership_date)}.  #{link_to("Renew Eastern League Membership", new_user_membership_path(user))}"
      class_name = "alert_warning"
    end
    content_tag :h4, message, :class => class_name    
  end
  
end
