require "rails_helper"

RSpec.describe "Password Reset", type: :request do
  context "when sending email" do
    let(:user) { create(:user)}
    before :each do
      ActionMailer::Base::deliveries.clear
    end

    it "should send reset email" do
      post password_resets_path, params: {password_reset: { email: user.email }}
      user.reload
      expect(ActionMailer::Base::deliveries.size).to eq(1)
      # reset_token is not available here, because it is just blong to instance varable inside the post request
      expect(user.reload.reset_digest).not_to eq(nil)
      expect(response).to redirect_to login_path
    end

    it "should not send mail with wrong email" do
      post password_resets_path, params: {password_reset: { email: "wrong@email.com" }}
      user.reload
      expect(ActionMailer::Base::deliveries.size).to eq(0)
      expect(user.reload.reset_digest).to eq(nil)
      expect(response).to render_template :new
    end

    it "should not send to the inactive email" do
      new_user = create(:user, :inactivated)
      post password_resets_path, params: {password_reset: { email: new_user.email }}
      expect(ActionMailer::Base::deliveries.size).to eq(0)
      expect(response).to render_template :new
    end

    it "should enter edit page with token & email" do
      user.set_reset 
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to render_template :edit
    end

    
  end
  context "when update password" do
    let(:user) { create(:user) }
    before :each do
      user.set_reset
      @valid_params = {
        id: user.reset_token,
        email: user.email,
        user: {
          password: "foobarzoo",
          password_confirmation: "foobarzoo"
        }}
    end
    it "should success with valid data" do
      patch password_reset_path(user.reset_token), params: @valid_params
      expect(response).to redirect_to user
    end
    
    it "should be invalid with empty password" do
      @valid_params[:user][:password] = ""
      @valid_params[:user][:password_confirmation] = ""
      patch password_reset_path(user.reset_token), params: @valid_params
      expect(response).to render_template :edit
    end

    it "shoulde be invalid with wrong token" do
      @valid_params[:id] = "wrong token"
      patch password_reset_path("wrong token"), params: @valid_params
      expect(response).to redirect_to root_url
    end

    it "shoulde be invalid with wrong email" do
      @valid_params[:email] = ""
      patch password_reset_path(user.reset_token), params: @valid_params
      expect(response).to redirect_to root_url
    end

    it "shoulde be invalid with wrong password/confirmation" do
      @valid_params[:user][:password] = "foobarzoo"
      @valid_params[:user][:password_confirmation] = "notcomfirmed"
      patch password_reset_path(user.reset_token), params: @valid_params
      expect(response).to render_template :edit
    end

    
  end
end
