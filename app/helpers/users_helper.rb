module UsersHelper
  
  def membership_status_display(user)
    case user.membership_status
    when "active"
      message = "Your Eastern League membership is in good standing. "
      message += "(Board Member)" if user.board_member?
      message += "(Lifetime Member)" if user.lifetime?
      message += "Your membership is valid through #{l(user.current_through_date, :format => :membership_date)}." if !user.board_member? && !user.lifetime?
      class_name = "alert_info"
    when "expired"
      message = "Your Eastern League Membership has expired (#{l(user.current_through_date, :format => :membership_date)}).  #{link_to("Renew Eastern League Membership", new_user_membership_path(user))}"
      class_name = "alert_error"
    when "expiring_soon"
      message = "Your Eastern League Membership will expire on #{l(user.current_through_date, :format => :membership_date)}.  #{link_to("Renew Eastern League Membership", new_user_membership_path(user))}"
      class_name = "alert_warning"
    end
    content_tag :h4, raw(message), :class => class_name    
  end
  
end
