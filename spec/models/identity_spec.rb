require "rails_helper"

RSpec.describe Identity, type: :model do

  describe "::create_user_with_identity" do
    before :each do
      @response = {
        name: "name",
        email: "new_email@email.com",
        image_url: "https://robohash.org/inexpeditaveniam.png?size=300x300&set=set1",
        uid: "valid_id_from_provider"
      }
      @provider = "valid_provider"
    end

    context "with valid response" do
      it "should create user with identity" do
        new_user = Identity.create_user_with_identity(@response, @provider)
        expect(new_user).to be_persisted
      end
    end

    context "with invalid response" do
      it "should be fail with duplicate pairs of provider & uid" do
        new_user = Identity.create_user_with_identity(@response, @provider)
        expect(new_user).to be_persisted
        expect(Identity.create_user_with_identity @response, @provider).to be_nil
      end

      it "should be fail with invalid image_url" do
        @response[:image_url] = "somthing_cant_open_as_url"
        new_user = Identity.create_user_with_identity(@response, @provider)
        expect(new_user).to be_persisted
        expect(new_user.identities).to be_present
        expect(new_user.avatar).to be_present
      end

      it "should be fail without uid" do
        @response[:uid] = nil
        expect(Identity.create_user_with_identity(@response, @provider)).to be_nil
      end
      
      it "should be fail without provider" do
        @provider = nil
        expect(Identity.create_user_with_identity(@response, @provider)).to be_nil
      end

    end 

  end
end
