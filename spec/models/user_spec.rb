require 'rails_helper'

RSpec.describe User, type: :model do

  describe "::create with UserRegisterForm" do

    let(:user) { build(:user, :inactivated) }
    context "with user's name" do
      it "should not be blank" do
        user = build(:user, name: " ")
        @register = create_UserRegisterForm(user) 
        expect(@register.save).to be false
      end
      
      it "should not longer than 51 words" do
        user = build(:user, name: "a" *52)
        @register = create_UserRegisterForm(user)
        expect(@register.save).to be false
      end
      
      it "should not shorter than 6 words" do
        user = build(:user, name: " ")
        @register = create_UserRegisterForm(user)
        expect(@register.save).to be false
      end
    end
    
    context "with user's email" do
      
      it "should not be blank" do
        user = build(:user, email: " ")
        @register = create_UserRegisterForm(user)
        expect(@register.save).to be false
      end
      
      it "should not longer thant 255 words" do
        user = build(:user, email: "a" * 244 + "@example.com")
        @register = create_UserRegisterForm(user)
        expect(@register.save).to be false
      end
      
      it "should not be repulicate" do
        user.save
        duplicate_user = user.dup
        expect(duplicate_user).not_to be_valid
      end
      
      it "should not be case sensitive" do
        user1 = create(:user, email: "test1@email.com")
        user2 = build(:user, email: "TEST1@email.com")
        expect(user2).not_to be_valid
      end
      #
      it "should be a valid address" do
        invalid_emails = %w[ example example@ @example example@test example@test. example@test.com.]
        invalid_emails.each do |mail|
          user = build(:user, email: mail)
          @register = create_UserRegisterForm(user)
          expect(@register.save).to be false
        end
      end
      
    end
    
    context "with user's password and password_confirmation" do
      
      it "should not be blank" do
        user = build(:user, password: " ", password_confirmation: " ")
        expect(user).not_to be_valid
      end
      
      it "should not only with password" do
        user = build(:user, password_confirmation: "")
        expect(user).not_to be_valid
      end
      
      it "should not only with confirmation" do
        user = build(:user, password: "")
        expect(user).not_to be_valid
      end
      
      it "should not shorter than 8 words" do 
        user = build(:user, password: "a" * 7, password_confirmation: "a" * 7)
        expect(user).not_to be_valid
      end
      
      it "should not longer than 51 words" do
        user = build(:user, password: "a" * 52, password_confirmation: "a" * 52)
        expect(user).not_to be_valid
      end
      
      it "should be case sensitive" do
        user = build(:user, password: "password", password_confirmation: "PASSWORD")
        expect(user).not_to be_valid
      end
      
      it "should be comfirmed" do
        user = build(:user, password: "aaaaaaaa", password_confirmation: "bbbbbbbb")
        expect(user).not_to be_valid
      end
      
    end
    
    context "with admin" do
      it "should never be nil" do
        expect(user.admin).not_to be_nil
      end
      
      it "should be false by default" do
        expect(user.admin).to be false
      end
    end

    context "with activate" do
      let(:user) {create(:user, :inactivated) }
      it "should be inactivate by default" do
        expect(user.activated).to be false
      end
      it "should set activated token and digest after call authenticator" do
        User::Authenticator.new(user, :activated).set
        expect(user.activated_token).to be_present
        expect(user.activated_digest).to be_present
      end
      
    end
    
    context "with valid inforamtion" do
      it "should create successfullly" do
        expect(user).to be_valid
        @register = create_UserRegisterForm(user)
        expect(@register.save).to be true
      end
    end   
  end

  describe "::update with UserUpdateForm" do
    let!(:user) { create(:user) }
    before :each do
      @params = { 
        name: "correct_name",
        email: "correct_email@email.com",
        password: "correct_password",
        password_confirmation: "correct_password"
      }
    end
    context "with valid update" do
      it "should be valid" do
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater.user).to eq user
        expect(@updater.update).to be true
        expect(user.name).to eq "correct_name"
        expect(user.email).to eq "correct_email@email.com"
        expect(user.password).to eq "correct_password"
      end
    end
    context "with user's name" do
      it "should be exist" do
        @params[:name] = ""
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater).not_to be_valid
        expect(@updater.update).to be false
      end

      it "should be more than 6 char" do
        @params[:name] = "a"*5
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater).not_to be_valid
        expect(@updater.update).to be false
      end

      it "should be less than 51 char" do
        @params[:name] = "a"*52
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater).not_to be_valid
        expect(@updater.update).to be false
      end
    end

    context "with user's email" do
      it "should exist" do
        @params[:email] = ""
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater.update).to be false
        expect(@updater).not_to be_valid
      end

      it "should less than 255 chars" do
        @params[:email] = "a" * 256
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater.update).to be false
        expect(@updater).not_to be_valid
      end

      it "should not repeat other's email" do
        other_user = create(:user)
        @params[:email] = other_user.email
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater.update).to be false
        expect(@updater.user).not_to be_valid
      end

      it "is fine to update with your email" do
        @params[:email] = user.email
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater.update).to be true
      end
    end

    context "with user's password & confirmation" do
        
      # it "should be valid with blank password & confirmation" do
      #   @params[:password] = @params[:password_confirmation] = ""
      #   @updater = create_UserUpdateForm(@params, user)
      #   byebug
      #   expect(@updater.update).to be true
      #   expect(user.password).to eq "password"
      # end

      it "should not be valid with blank password but new confirmation" do
        @params[:password_confirmation] = "new_password"
        @updater = create_UserUpdateForm(@params, user)
        expect(@updater.update).to be false
      end
      
    end

  end
  
  describe "#password reset" do
    context "when called" do
      let!(:user) { create(:user) }
      it "should create reset token and reset digest" do
          User::Authenticator.new(user, :reset).set
          user.reload
          expect(user.reset_token).to be_present
          expect(user.reset_digest).to be_present
      end
    end
  end
    
end
