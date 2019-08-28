FactoryBot.define do
  factory :user, class: User do
    id { 100 }
    name { "MyString" }
    email { "MyString@email.com" }
    password {"password"}
    password_confirmation {"password"}
    admin { true }
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :other_user, class: User do 
    name { "other_user" }
    email { "other_usrs@email.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :new_user, class: User do 
    name { "new_user" }
    email { "new_usr@email.com" }
    password { "password" }
    password_confirmation { "password" }
    
  end

end
