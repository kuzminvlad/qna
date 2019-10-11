require_relative '../acceptance_helper'

feature 'Add comments to question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Not authorized user try to comment question', js: true do
    visit question_path(question)

    expect(page).to have_selector '.question-comment-form', text: ''
  end

  scenario 'Authorized user comments question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question-comment-form' do
      fill_in 'Your comment:', with: 'Question comment'
      click_on 'Comment'
    end

    expect(page).to have_content user[:email]
    expect(page).to have_content 'Question comment'
  end
end
