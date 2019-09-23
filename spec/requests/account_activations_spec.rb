require "rails_helper"

RSpec.describe "account_activation", type: :request do 
  describe "#edit" do
    context "with correct token and email" do
      let(:user) { create(:user, :inactivated) }
      it "should activate the new account" do
        User::Authenticator.new(user, :activated).set
        get edit_account_activation_url(user.activated_token, email: user.email)
        expect(user.reload.activated).to eq(true)
        expect(is_logged_in?).to eq(true)
      end
    end
  end
end