FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { "MyString@email.com" }
    password {"password"}
    password_confirmation {"password"}
  end
end
