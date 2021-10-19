FactoryBot.define do
  factory :region, class: Place do
    name_jp { "東アジア" }
    name_en { "East Asia" }
    ancestry{ nil }
  end

  factory :country, class: Place do
    code { "JP" }
    name_jp { "日本" }
    name_en { "Japan" }
    ancestry{ "1" }
  end

  factory :city, class: Place do
    code { "JP" }
    name_jp { "福岡" }
    name_en { "Fukuoka" }
    ancestry{ "1/265" }
  end
  
end
