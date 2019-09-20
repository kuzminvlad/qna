FactoryBot.define do
  factory :answer do
    question
    body { "MyText" }
    user
  end

  factory :invalid_answer, class: "Answer" do
    question { nil }
    body { nil }
    user { nil }
  end
end
