require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#account_activation" do
    context "when activate new account" do
      let(:user) { create(:new_user) }

      it "should send email" do
        mail = UserMailer.account_activation(user)
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["noreply@example.com"])
        expect(mail.subject).to eq("Account Activation")
        expect(mail.body.encoded).to match(user.activated_token)
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end
      
    end
  end
end
