require_relative '../acceptance_helper'

feature 'Best answer', '
  In order to view best answer
  As an authorized user and owner of question
  I want to be able choose best answer
' do
  given(:user) { create(:user) }
  given(:user_another) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }

  scenario 'Not authorized user tries to set best answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Best'
  end

  scenario 'Authorized user and not owner of question tries to set best answer' do
    sign_in(user_another)
    visit question_path(question)
    expect(page).to_not have_content 'Best'
  end

  scenario 'Owner of question tries to set best answer', js: true do
    sign_in(user)
    visit question_path(question)

    within("#answer-#{answer1.id}") do
      click_on 'Best'
      expect(page).to have_content 'Best answer'
    end
  end
end
