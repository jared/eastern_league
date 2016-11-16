require 'spec_helper'

RSpec.describe CommentsController, type: :controller do 
  describe "#create" do
    before(:each) do
      @event = FactoryGirl.create :event
      login_as FactoryGirl.create(:active_user)
      
    end

    it "should save the comment" do
      expect { 
        post :create, event_id: @event.id, comment: { comment: "Anyone looking to share a ride?" }
      }.to change(Comment, :count).by 1
    end

    it "should associate the comment with the event" do
      post :create, event_id: @event.id, comment: { comment: "Anyone looking to share a ride?" }
      expect(assigns(:comment).commentable).to eq @event
    end

    it "should redirect back to the event page" do
      post :create, event_id: @event.id, comment: { comment: "Anyone looking to share a ride?" }
      expect(response).to redirect_to @event
    end

  end
end
