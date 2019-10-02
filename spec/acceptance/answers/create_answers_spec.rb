require_relative '../acceptance_helper'

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authorized user
  I want to be able create answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authorized user create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  context 'Multiple sessions' do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path(question)
      end

      Capybara.using_session('guest') do
        visit questions_path(question)
      end

      Capybara.using_session('user') do 
        fill_in 'Your answer', with: 'My answer'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Create'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'My answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My answer'
      end
    end
  end
end
