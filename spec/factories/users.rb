FactoryBot.define do
  factory :user do
    name { "一般ユーザー" }
    email { "general@ex.com" }
    password { "password" }
    admin { false }
    confirmed_at { Time.now }
  end

  factory :second_user, class: User do
    name { "管理ユーザー" }
    email { "admin@ex.com" }
    password { "password" }
    admin { true }
    confirmed_at { Time.now }
  end
  
end