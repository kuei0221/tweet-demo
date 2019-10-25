require "rails_helper"
require "rest-client"
require "#{Rails.root}/app/services/oauth_logger"

RSpec.describe "oath_logger", type: :request do
  context "env setting" do
    it "should connect to facebook through webmock" do
      url = "https://graph.facebook.com/v4.0/me"
      response = RestClient.get(url)
      expect(response.code).to eq 200
    end

    it "should connect to google through webmock" do
      url = "https://oauth2.googleapis.com/tokeninfo"
      response = RestClient.get(url)
      expect(response.code).to eq 200
    end

    it "should have access to oauthlogger" do
      expect(OauthLogger.class).not_to be nil
    end
  end

  context "with invalid data" do
    it "should fail with invalid provider" do
      @provider = "invalid_provider"
      post oauth_path(@provider), params: { token: "valid_token", format: :js}
      expect(is_logged_in?).to be false
      expect(flash[:danger]).to eq "Login fail with #{@provider}"
      expect(response.body).to include "window.location = '#{login_path}'"
    end
  end
  
  %w[facebook google].each do |provider|
    context "with login through provider: #{provider}" do
      before do
        @provider = "#{provider}"
        @token = "valid_#{provider}_token"
        @uid = "testing-#{provider}-uid"
      end
      it "should success login without any other setting" do
        post oauth_path(@provider), params: { token: @token, format: :js} 
        expect(is_logged_in?).to be true
        expect(response.body).to include "window.location = '#{root_path}'"
      end
      
      context "with identity user" do
        let(:user) { create(:user) }
        it "should login straigthly" do
          user.identities.create!(provider: @provider, uid: @uid)
          post oauth_path(@provider), params: { token: @token, format: :js} 
          expect(is_logged_in?).to be true
          expect(flash[:notice]).to eq "You have connected with #{@provider.capitalize} already."
        end
      end
      
      context "with confirmed email's user" do
        before do
          @user = create(:user, email: "testing-email@email.com")
        end
        it "should login as email's user and build connection" do
          post oauth_path(@provider), params: { token: @token, format: :js}
          expect(User.find_by(email: "testing-email@email.com")).to be_present
          expect(@user.reload.identities.find_by(provider: @provider, uid: @uid)).to be_present
          expect(is_logged_in?).to be true
          expect(flash[:notice]).to eq "This email has already been sign up, will generate connection with it"
        end
      end
      
      context "without any setting" do
        it "it should login and create new user with identities" do
          post oauth_path(@provider), params: { token: @token, format: :js}
          expect(User.find_by(email: "testing-email@email.com")).to be_present
          expect(Identity.find_by(provider: @provider, uid: @uid)).to be_present
          expect(is_logged_in?).to be true
          expect(flash[:notice]).to eq "Sign in as a new user with #{@provider.capitalize}."
        end
      end
    end

  end
  
end