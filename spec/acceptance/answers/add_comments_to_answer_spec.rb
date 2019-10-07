require_relative '../acceptance_helper'

feature 'Add comments to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Not authorized user try to comment answer', js: true do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content 'Your comment'
    end
  end

  scenario 'Authorized user comments answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      within '.answer-comment-form' do
        fill_in 'Your comment:', with: 'Answer comment'
        click_on 'Comment'
      end
      within '.Answer-comments' do
        # expect(page).to have_content user[:email]
        # expect(page).to have_content 'Answer comment'
      end
    end
  end
end