require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user created question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Your question', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_content 'Your question sucessfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path

    expect(page).not_to have_link 'Ask Question'
  end

  context 'Multiple sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask Question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Your question', with: 'text text'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Create'
        expect(page).to have_content 'Your question sucessfully created.'
        # expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        # expect(page).to have_content 'Test question'
      end
    end
  end
end
