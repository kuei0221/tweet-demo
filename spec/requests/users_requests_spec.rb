require "rails_helper"

RSpec.describe "users#create", type: :request do
  context "when create new user" do
    let(:user) {build(:user)}
    
    it "should success with valid data" do
      post users_path, params: { user:{ name: user.name,
                                        email: user.email,
                                        password: user.password,
                                        password_confirmation: user.password_confirmation
                                        }}
      expect(flash[:success]).not_to eq(nil)
      expect(response).to redirect_to action: :show, id: assigns(:user).id
    end

    it "should fail with invalid data" do
      post users_path, params:{ user:{name: user.name} }
      expect(flash[:danger]).not_to eq(nil)
      expect(response).to render_template :new
    end
  end
end