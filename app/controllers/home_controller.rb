class HomeController < ApplicationController

  def index
    @announcements = Announcement.recent
    @photos = flickr.groups.pools.getPhotos(:group_id => "1888762@N20", :page => 1, :per_page => 8)
  end

end
