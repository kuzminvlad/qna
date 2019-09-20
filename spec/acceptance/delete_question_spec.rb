require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question
  As an authenticated user and owner of this question
  I want to be able to delete question
} do
  given(:user) { create(:user) }
  given(:user_another) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user tries to delete not his question' do
    sign_in(user_another)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Not authenticated user tries to delete any question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
