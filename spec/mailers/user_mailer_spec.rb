require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#account_activation" do
    context "when activate new account" do
      let(:user) { create(:user, :inactivated) }
      it "should send email" do
        User::Authenticator.new(user, :activated).set 
        mail = UserMailer.account_activation(user)
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["noreply@mytweet-demo.com"])
        expect(mail.subject).to eq("Account Activation")
        expect(mail.body.encoded).to match(user.activated_token)
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end
    end
  end
  
  describe "#password_reset" do
    context "When password reset" do
      let(:user) { create(:user) }
      it "should send correct mail" do
        User::Authenticator.new(user, :reset).set 
        mail = UserMailer.password_reset(user)
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["noreply@mytweet-demo.com"])
        expect(mail.subject).to eq("Password Reset")
        expect(mail.body.encoded).to match(user.reset_token)
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end
    end
  end
end
