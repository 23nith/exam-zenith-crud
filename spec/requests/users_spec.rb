require 'rails_helper'

RSpec.describe "Users", type: :request do
    # Get all users
    describe "GET /users" do
      before do
        @user = create(:user)
        sign_in @user
      end
  
      it "Returns response 200" do
        get "/users"
        expect(response).to have_http_status(:success)
      end
  
      it "Returns json with items equal to count of all existing Users" do
        get '/users'
  
        expect(response).to have_http_status(:success)
        users = JSON.parse(response.body)
        expect(users.count).to eq(User.all.count)
      end
    end
  
    # Show user
    describe "POST /user" do
      before do
        @user = create(:user)
        sign_in @user
      end

      let!(:user1) {User.create!(
        name: "user1",
        email: "user1@email.com",
        phone_number: "12344312",
        password: "password",
        role: "user"
      )}
  
      it "Returns response 200" do
        post "/user", params: {id: user1.id}
        expect(response).to have_http_status(:success)
      end
  
      it "Returns the json with id equal to parameter id passed" do
        post "/user", params: {id: user1.id}
        user = JSON.parse(response.body)
        expect(user["id"]).to match(user1.id)
      end
    end
  
    # Add user
    describe "POST /add_user" do
  
      context "Current user is admin" do
        before do
          @user = create(:user)
          @user.role = "admin"
          sign_in @user
        end
  
        it "Returns response successful" do 
          post "/add_user", params: {user: {name: "name", email: "email@email.com", password: "password", phone_number: "321123", role: "user"}}
  
          expect(response).to have_http_status(:success)
        end
  
        it "Will increase the count of users" do
          expect {post "/add_user", params: {user: {name: "name", email: "email@email.com", password: "password", phone_number: "321123", role: "user"}}}. to \
        change(User, :count)
        .by(1)
        end
      end
  
      context "Current user is not admin" do
        before do
          @user = create(:user)
          @user.role = "user"
          sign_in @user
        end
  
  
        it "Returns response 403" do
          post "/add_user", params: {user: {name: "name", email: "email@email.com", password: "password", phone_number: "321123", role: "user"}}
          
          expect(response).to have_http_status(403)
        end
      end
  
    end
  
    # Edit user
    describe "POST /edit_user" do
      context "Current user is admin" do
        before do
          @user = create(:user)
          sign_in @user
        end    

        let!(:user1) {User.create!(
          name: "user1",
          email: "user1@email.com",
          phone_number: "12344312",
          password: "password",
          role: "user"
        )}
  
        it "Returns response successful" do 
  
          post "/edit_user", params: {id: user1.id, user: {name: "edited_name", email: "user1@email.com", phone_number: "12344312", password: "password", role: "user"}}

          expect(response).to have_http_status(:success)
        end
  
        it "Returns json with field equal to updated value" do

          post "/edit_user", params: {id: user1.id, user: {name: "edited_name", email: "user1@email.com", phone_number: "12344312", password: "password", role: "user"}}

          the_user = JSON.parse(response.body)
          expect(the_user["name"]).to eq "edited_name"
        end
      end
  
      context "Current user is not admin" do
        before do
          @user = create(:user)
          @user.role = "user"
          sign_in @user
        end    

        let!(:user1) {User.create!(
          name: "user1",
          email: "user1@email.com",
          phone_number: "12344312",
          password: "password",
          role: "user"
        )}
  
        it "Returns response 403" do
          post "/edit_user", params: {id: user1.id, user: {name: "edited_name", email: "user1@email.com", phone_number: "12344312", password: "password", role: "user"}}
  
          expect(response).to have_http_status(:forbidden)
        end
      end

    end
  
    # Delete user
    describe "DELETE /user" do
  
      context "Current user is admin" do
        before do
          @user = create(:user)
          sign_in @user
        end 
  

        let!(:user1) {User.create!(
          name: "user1",
          email: "user1@email.com",
          phone_number: "12344312",
          password: "password",
          role: "user"
        )}
  
        it "Returns response successful" do 
          delete "/user", params:{id: user1.id}
          expect(response).to have_http_status(:success)
        end
  
        let!(:user1) {User.create!(
          name: "user1",
          email: "user1@email.com",
          phone_number: "12344312",
          password: "password",
          role: "user"
        )}
  
        it "Decreases the count of users" do
          expect {delete "/user", params: {id: user1.id}}. to \
        change(User, :count)
        .by(-1)
        end
      end
  
      context "Current user is not admin" do
        before do
          @user = create(:user)
          @user.role = "user"
          sign_in @user
        end 

        let!(:user1) {User.create!(
          name: "user1",
          email: "user1@email.com",
          phone_number: "12344312",
          password: "password",
          role: "user"
        )}

        it "Returns response 403" do
          delete "/user", params:{id: user1.id}
          expect(response).to have_http_status(403)
        end
      end
  
    end
end
