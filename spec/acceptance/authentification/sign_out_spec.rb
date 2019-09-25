require_relative '../acceptance_helper'

feature 'User sign out', %q{
  In order to end session
  As an user
  I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user sign out' do
    sign_in(user)
    find("a[href='#{destroy_user_session_path}']").click

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
