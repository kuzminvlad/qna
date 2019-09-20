require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete answer
  As an authenticated user and owner of this answer
  I want to be able to delete answer
}  do
  given(:user) { create(:user) }
  given(:user_another) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user delete his answer' do
    sign_in(user)
    visit answer_path(answer)
    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to delete not his answer' do
    sign_in(user_another)
    visit answer_path(answer)
    #
    # expect(page).to_not have_link 'Delete'
  end

  scenario 'Not Authenticated user tries to delete answer' do
    visit answer_path(answer)

    expect(page).to_not have_link 'Delete'
  end
end
