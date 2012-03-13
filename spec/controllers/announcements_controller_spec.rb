require 'spec_helper'

describe AnnouncementsController do
  
  context "GET actions" do

    shared_examples_for "a non-admin user" do
      it "should deny access" do
        send @method, @action, @params
        response.should be_redirect
      end
    end
    
    context "show" do
      before(:each) do
        @announcement = Factory :announcement
      end
      
      it "should render the show template" do
        get :show, :id => @announcement.id
        response.should render_template :show
      end
      
      it "should instantiate the announcement object" do
        get :show, :id => @announcement.id
        assigns(:announcement).should == @announcement
      end
      
    end

    context "index" do
      before(:each) do
        2.times { Factory(:announcement) }
      end
    
      context "as an admin" do
        before(:each) do
          @admin = Factory(:user, :admin => true)
          login_as(@admin)
        end
      
        it "should allow access" do
          get :index
          response.should be_success
        end
      
        it "should grab the list of announcements" do
          get :index
          assigns(:announcements).should_not be_empty
        end
      end
    
      context "as a non-admin" do
        before(:each) do
          @method = :get
          @action = :index
          @params = {}
        end
      
        it_should_behave_like "a non-admin user"
      end
    
    end
  
    context "GET new" do
      context "as an admin" do
        before(:each) do
          @admin = Factory(:user, :admin => true)
          login_as(@admin)
        end
      
        it "render the new announcement form" do
          get :new
          response.should render_template :new
        end
      
      end
      
      context "as a non-admin" do
        before(:each) do
          @method = :get
          @action = :new
          @params = {}
        end

        it_should_behave_like "a non-admin user"
      end
          
    end

    context "GET edit" do
      before(:each) do
        @announcement = Factory :announcement
      end
    
      context "as an admin" do
        before(:each) do
          @admin = Factory(:user, :admin => true)
          login_as(@admin)
        end
      
        it "render the new announcement form" do
          get :edit, :id => @announcement.id
          response.should render_template :edit
        end
      
      end
      
      context "as a non-admin" do
        before(:each) do
          @method = :get
          @action = :edit
          @params = {:id => @announcement.id}
        end

        it_should_behave_like "a non-admin user"
      end
          
    end

  end
  
  context "POST actions" do
    
    context "create" do
      context "for an admin user" do
        before :each do
          @admin = Factory :user, :admin => true
          login_as @admin
        end
        context "with valid parameters" do
          before(:each) do
            @params = {:announcement => { :headline => "Some Text", :body => "Some more text"}}
          end
          
          it "should create a new announcement" do
            lambda do
              post :create, @params
            end.should change(Announcement, :count).by 1
          end
          
          it "should redirect to the index page" do
            post :create, @params
            response.should redirect_to announcements_path
          end
          
        end
        
        context "with invalid parameters" do
          before(:each) do
            @params = {}
          end
          
          it "should not create a new announcement" do
            lambda do
              post :create, @params
            end.should_not change(Announcement, :count)
          end
          
          it "should re-render the new template" do
            post :create, @params
            response.should render_template :new
          end
          
        end
      end
      
      context "for a non-admin" do
        before(:each) do
          @method = :post
          @action = :create
          @params = {:announcement => { :headline => "Some Text", :body => "Some more text"}}
        end

        it_should_behave_like "a non-admin user"
      end
    end
    
  end

  context "PUT actions" do
    
    context "update" do
      context "for an admin user" do
        before :each do
          @announcement = Factory :announcement
          @admin = Factory :user, :admin => true
          login_as @admin
        end
        context "with valid parameters" do
          before(:each) do
            @params = {:id => @announcement.id, :announcement => { :headline => "Some Text", :body => "Some more text"}}
          end
          
          it "should update an announcement" do
            put :update, @params
            assigns(:announcement).headline.should == "Some Text"
          end
          
          it "should redirect to the index page" do
            put :update, @params
            response.should redirect_to announcements_path
          end
          
        end
        
        context "with invalid parameters" do
          before(:each) do
            @params = {:id => @announcement.id, :announcement => { :body => nil }}
          end
          
          it "should re-render the new template" do
            put :update, @params
            response.should render_template :edit
          end
          
        end
      end
      
      context "for a non-admin" do
        before(:each) do
          @announcement = Factory :announcement
          @method = :put
          @action = :update
          @params = {:id => @announcement.id, :announcement => { :headline => "Some Text", :body => "Some more text"}}
        end

        it_should_behave_like "a non-admin user"
      end
    end
    
  end
  
  context "DELETE actions" do
    
    context "destroy" do
      context "for an admin user" do
        before :each do
          @announcement = Factory :announcement
          @admin = Factory :user, :admin => true
          login_as @admin
        end
        context "with valid parameters" do
          before(:each) do
            @params = {:id => @announcement.id}
          end
          
          it "should delete an announcement" do
            lambda do
              delete :destroy, @params
            end.should change(Announcement, :count).by(-1)
          end
          
          it "should redirect to the index page" do
            delete :destroy, @params
            response.should redirect_to announcements_path
          end
          
        end
        
      end
      
      context "for a non-admin" do
        before(:each) do
          @method = :delete
          @action = :destroy
          @params = {:id => Factory(:announcement).id}
        end

        it_should_behave_like "a non-admin user"
      end
    end
    
  end
  

end
