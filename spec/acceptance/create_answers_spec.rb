require 'rails_helper'

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authentificated user
  I want to be able create answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authentificated user create answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Add answer'
    fill_in 'Your answer', with: 'My answer'
    click_on 'Create answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end
end
