FactoryBot.define do
  factory :blog do
    title { "Blog1" }
    content { "ContentContentContentContent" }
  end

  factory :blog2, class: Blog do
    title { "Blog2" }
    content { "ContentContentContentContent" }
  end

end