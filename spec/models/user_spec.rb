require 'rails_helper'

RSpec.describe User, type: :model do

  describe "::create" do
    let(:user) { build(:new_user) }
    context "with user's name" do
      it "should not be blank" do
        user = build(:user, name: " ")
        user.save
        expect(user.valid?).to eq(false)
      end
  
      it "should not longer than 51 words" do
        user = build(:user, name: "a" *52)
        user.save
        expect(user.valid?).to eq(false)
        #expect(user).to be_valid
      end
  
      it "should not shorter than 6 words" do
        user = build(:user, name: " ")
        # user.save valid>save
        expect(user.valid?).to eq(false)
      end
    end
  
    context "with user's email" do
  
      it "should not be blank" do
        user = build(:user, email: " ")
        user.save
        expect(user.valid?).to eq(false)
      end
  
      it "should not longer thant 255 words" do
        user = build(:user, email: "a" * 244 + "@example.com")
        user.save
        expect(user.valid?).to eq(false)
      end
      
      it "should not be repulicate" do
        user.save
        duplicate_user = user.dup
        duplicate_user.save
        expect(duplicate_user.valid?).to eq(false)
      end
      
      it "should not be case sensitive" do
        user1 = User.create(name: "account1", email: "test1@email.com", password: "password")
        user2 = User.create(name: "account2", email: "TEST1@email.com", password: "password")
        expect(user2.valid?).to eq(false)
      end
      
      it "should be a valid address" do
        invalid_emails = %w[ example example@ @example example@test example@test. example@test.com.]
        invalid_emails.each do |mail|
          user.email = mail
          user.save
          expect(user.valid?).to eq(false), "#{mail} should be invalid"
        end
      end
  
    end
  
    context "with user's password and password_confirmation" do
  
      it "should not be blank" do
        user = build(:user, password: " ", password_confirmation: " ")
        user.save
        expect(user.valid?).to eq(false)
      end
  
      it "should not only with password" do
        user = build(:user, password_confirmation: "")
        user.save
        expect(user.valid?).to eq(false)
      end
  
      it "should not only with confirmation" do
        @user = User.create(name: user.name, email: user.email, password_confirmation: "password")
        expect(@user.valid?).to eq(false)
      end
  
      it "should not only with confirmation" do
        user = build(:user, password: "")
        user.save
        expect(user.valid?).to eq(false)
      end
  
      it "should not shorter than 8 words" do 
        user = build(:user, password: "a" * 7, password_confirmation: "a" * 7)
        user.save
        expect(user.valid?).to eq(false)
      end
  
      it "should not longer than 51 words" do
        user = build(:user, password: "a" * 52, password_confirmation: "a" * 52)
        user.save
        expect(user.valid?).to eq(false)
      end
  
      it "should be case sensitive" do
        user = build(:user, password: "password", password_confirmation: "PASSWORD")
        user.save
        expect(user.valid?).to eq(false)
      end
  
      it "should be comfirmed" do
        user = build(:user, password: "aaaaaaaa", password_confirmation: "bbbbbbbb")
        user.save
        expect(user.valid?).to eq(false)
      end
  
    end

    context "with admin" do
      it "should never be nil" do
        user.save
        expect(user.admin.nil?).to eq(false)
      end

      it "should be false by default" do
        user.save
        expect(user.admin).to eq(false)
      end
    end

    context "with activate" do
      let(:user) {create(:new_user) }
      it "should be inactivate by default" do
        expect(user.activated).to eq(false)
      end

      it "should auto set activated token and digest" do
        expect(user.activated_token.empty?).to eq(false)
        expect(user.activated_digest.empty?).to eq(false)
      end
      
    end

  end

  describe "#set reset" do
    context "when called" do
      let!(:user) { create(:user) }
      it "should create reset token and reset digest" do
        user.set_reset
        user.reload
        expect(user.reset_token).not_to eq(nil)
        expect(user.reset_digest).not_to eq(nil)
      end
    end
  end
    
end
