require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {create(:user)}
  context "with user's name" do
    it "should not be blank" do
      user.name = " "
      expect(user.valid?).to eq(false)
    end

    it "should not longer than 51 words" do
      user.name = "a" * 52
      expect(user.valid?).to eq(false)
    end

    it "should not shorter than 6 words" do
      user.name = "a" * 5
      expect(user.valid?).to eq(false)
    end
  end

  context "with user's email" do

    it "should not be blank" do
      user.email = " "
      expect(user.valid?).to eq(false)
    end

    it "should not longer thant 255 words" do
      user.email = "a" * 244 + "@example.com"
      expect(user.valid?).to eq(false)
    end
    
    it "should not be repulicate" do
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
        expect(user.valid?).to eq(false), "#{mail} should be invalid"
      end
    end

  end

  context "with user's password and password_confirmation" do

    it "should not be blank" do
      user.password = user.password_confirmation = " "
      expect(user.valid?).to eq(false)
    end

    it "should not shorter than 8 words" do 
      user.password = user.password_confirmation = "a" * 7
      expect(user.valid?).to eq(false)
    end

    it "should not longer than 51 words" do
      user.password = user.password_confirmation = "a" * 52 
      expect(user.valid?).to eq(false)
    end

    it "should be case sensitive" do
      user.update(password: "password", password_confirmation: "PASSWORD")
      expect(user.valid?).to eq(false)
    end

    it "should be comfirmed" do
      user.password = "aaaaaaaa"
      user.password_confirmation = "bbbbbbbb"
      expect(user.valid?).to eq(false)
    end

  end
    
end
