require_relative '../acceptance_helper'

feature 'Votes for questions', '
  In order to give vote for question
  As an authorized user
  I want to give vote for questions, except my questions
' do
  given(:user) { create(:user) }
  given(:user_another) { create(:user) }
  given!(:question) { create(:question, user: user_another) }

  scenario 'Unauthorized user try to give vote for question' do
    visit question_path(question)
    expect(page).to_not have_link 'up'
    expect(page).to_not have_link 'down'
    expect(page).to_not have_link 'clear'
  end

  scenario 'Authorized user try to give vote for his answer' do
    sign_in(user_another)
    visit question_path(question)

    expect(page).to_not have_link 'up'
    expect(page).to_not have_link 'down'
    expect(page).to_not have_link 'clean'
  end

  scenario 'Authorized user try to give vote for answer of other users', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_button 'up'
    expect(page).to have_button 'down'
    expect(page).to have_button('up', disabled: false)
    expect(page).to have_button('down', disabled: false)
    expect(page).to have_button('clean', disabled: true)

    click_on 'up'
    expect(page).to have_button('up', disabled: true)
    expect(page).to have_button('down', disabled: true)
    expect(page).to have_button('clean', disabled: false)
    expect(page).to have_content 'Raiting:1'

    click_on 'clean'
    expect(page).to have_button('up', disabled: false)
    expect(page).to have_button('down', disabled: false)
    expect(page).to have_button('clean', disabled: true)
    expect(page).to have_content 'Raiting:0'

    click_on 'down'
    expect(page).to have_content 'Raiting:-1'
  end
end
