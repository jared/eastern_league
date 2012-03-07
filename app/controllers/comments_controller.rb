class CommentsController < ApplicationController
  
  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.build(params[:comment].merge(:user_id => current_user.id))
    @comment.save
    redirect_to event_path @event
  end
  
end
