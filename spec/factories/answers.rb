FactoryBot.define do
  factory :answer do
    question_id { nil }
    body { "MyText" }
  end

  factory :invalid_answer, class: "Answer" do
    question_id { nil }
    body { nil }
  end
end
