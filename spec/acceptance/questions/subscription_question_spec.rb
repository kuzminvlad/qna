require_relative '../acceptance_helper'

feature 'Subscribe question', '
  In order to subscribe to question
  As an authenticated user
  I want to subscribe or unsubscribe to questions
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authorized user subscribe/unsubscribe', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content 'Subscribe'
    click_on 'Subscribe'
    expect(page).to have_content 'Unsubscribe'
    click_on 'Unsubscribe'
    expect(page).to have_content 'Subscribe'
  end

  scenario 'Unauthorized user  tries to unsubscribe', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'
  end
end
