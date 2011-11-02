module MembershipsHelper
  
  def display_renewal_date(user)
    if user.current_through_date && user.current_through_date >= Date.today
      content_tag :h4, "Your membership is valid through #{l(user.current_through_date, :format => :membership_date)}.", :class => "alert_info"
    elsif user.current_through_date && user.current_through_date < Date.today
      content_tag :h4, "Your membership has expired! Your expiration date was #{l(user.current_through_date, :format => :membership_date)}.", :class => "alert_error"
    end
  end
  
end
