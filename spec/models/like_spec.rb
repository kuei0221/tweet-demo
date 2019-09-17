require 'rails_helper'

RSpec.describe Like, type: :model do

  let!(:user) { create(:user) }
  let!(:post) { create(:micropost) }

  context "when create" do
    it "should have micropost_id and user_id" do
      like = Like.new(micropost_id: post.id, user_id: user.id)
      expect(like).to be_valid
    end
    
    it "should have post's id" do
      like = Like.new(micropost_id: "", user_id: user.id)
      expect(like).to be_invalid
    end
    
    it "should have user id" do
      like = Like.new(micropost_id: post.id, user_id: "")
      expect(like).to be_invalid
    end

    it "should create from micropost#liked" do
      user.like post
      expect(post.liked_users.include? user).to be true
      expect(user.liked_posts.include? post).to be true 
    end
    
    it "should be true with user#liked?" do
      user.like post
      expect(user.liked? post).to be true
    end
    
    it "should increase micropost#likes_count" do
      expect{ user.like post }.to change{ post.likes_count }.by(1)
    end
  
    it "should not like again" do
      user.like post
      expect{ user.like post }.to raise_error(ActiveRecord::RecordNotUnique)
    end


  end
  
  context "when delete" do
    before :each do
      user.like post
    end
    it "should delete form micrpost#unlike" do
      user.unlike post
      expect(post.liked_users.include? user).to be false
      expect(user.liked_posts.include? post).to be false
    end
    
  end
end
