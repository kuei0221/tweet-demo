FactoryBot.define do
  factory :user, class: User do
    name { "MyString" }
    email { "MyString@email.com" }
    password {"password"}
    password_confirmation {"password"}
  end

  factory :other_user, class: User do 
    name { "other_user" }
    email { "other_usrs@email.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
