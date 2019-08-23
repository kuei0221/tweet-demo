require "rails_helper"

RSpec.describe "login process", type: :request do
  context "when login success" do
    let(:user) { create(:user) }
    context "with remember me" do
      it "should be success" do
        post login_path, params: { session: { email: user.email, 
                                                       password: user.password,
                                                       remember_me: "1" }}
        expect(is_logged_in?).to eq(true)
        expect(is_rememberred?(user.reload)).to eq(true)

        delete logout_path
        expect(is_logged_in?).to eq(false)
        expect(is_rememberred?(user)).to eq(false)
      end
    end

    context "without remember me" do
      it "should be success but not remember" do
        post login_path, params: { session: { email: user.email, 
                                              password: user.password,
                                              remember_me: "0" }}
        expect(is_logged_in?).to eq(true)
        expect(is_rememberred?(user.reload)).to eq(false)

        delete logout_path
        expect(is_logged_in?).to eq(false)
        expect(is_rememberred?(user)).to eq(false)
      end
    end

  end


end