FactoryBot.define do
  factory :trip do
    title { "Trip1" }
    start_on { "2022-11-02" }
    finish_on { "2022-12-02" }
    description { "Melbourne" }
  end

  factory :second_trip, class: Trip do
    title { "Trip2" }
    start_on { "2023-7-11" }
    finish_on { "2023-8-11" }
    description { "Sydney" }
  end
end