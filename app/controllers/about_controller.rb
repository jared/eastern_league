class AboutController < ApplicationController

  def index
  end

  def competitors
  end

  def organizers
  end

  def spectators
  end

  def links
  end

  def contact
    @commissioner = User.find(AdminSetting.first.commissioner_user_id)
  end

end
