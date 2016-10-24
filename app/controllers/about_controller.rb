class AboutController < ApplicationController

  def index
  end

  def competitors
  end

  def organizers
    load_commissioner
  end

  def spectators
  end

  def links
  end

  def contact
    load_commissioner
  end

  private

    def load_commissioner
      @commissioner = User.find(AdminSetting.first.commissioner_user_id)  
    end

end
