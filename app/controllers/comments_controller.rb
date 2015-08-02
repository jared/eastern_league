class CommentsController < ApplicationController
  
  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.build(comment_params.merge(:user_id => current_user.id))
    @comment.save
    redirect_to event_path @event
  end

private

  def comment_params
    params.require(:comment).permit(:comment)
  end
  
end
