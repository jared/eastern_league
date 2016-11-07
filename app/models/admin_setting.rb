class AdminSetting < ActiveRecord::Base

  belongs_to :commissioner_user, class_name: "User", foreign_key: "commissioner_user_id"

end
