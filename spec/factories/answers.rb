FactoryBot.define do
  factory :answer do
    question
    body { 'AnswerText' }
    user
    best { 'false' }
  end

  factory :invalid_answer, class: 'Answer' do
    question { nil }
    body { nil }
    user { nil }
  end
end
