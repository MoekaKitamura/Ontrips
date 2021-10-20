FactoryBot.define do
  factory :user do
    name { "General User" }
    email { "general@ex.com" }
    password { "password" }
    admin { false }
    confirmed_at { Time.now }
  end

  factory :second_user, class: User do
    name { "Admin User" }
    email { "admin@ex.com" }
    password { "password" }
    admin { true }
    confirmed_at { Time.now }
  end
  
end