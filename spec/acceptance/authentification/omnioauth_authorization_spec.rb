require_relative '../acceptance_helper'

feature 'Omniauth' do
  given(:user) { create(:user) }

  describe 'github' do
    it 'sign up new user' do
      visit new_user_registration_path
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    it 'add authorization to existing user' do
      user
      visit new_user_registration_path
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    it 'login user with existing authorization' do
      user.authorizations.create(provider: 'github', uid: '123456')
      visit new_user_registration_path
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    it 'handle authentication error' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_registration_path
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
    end
  end
end