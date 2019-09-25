require_relative '../acceptance_helper'

feature 'View list of questions', %q{
  In order to view list of question
  I want to be able to watch list of question
} do

  given(:question) { create(:question) }

  scenario 'user views questions' do
    question
    visit root_path
    expect(page).to have_content question.title
  end

 scenario 'user can view question and answers' do
    answer = create(:answer, question: question)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

end
