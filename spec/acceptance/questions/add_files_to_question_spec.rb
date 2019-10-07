require_relative '../acceptance_helper'

feature 'Add and delete files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach or delete files
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
  end

  scenario 'User adds file when asks question', js: true  do
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Your question', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User delete file from question', js: true do
    create(:question_attachment, attachmentable: question)
    visit edit_question_path(question)

    click_on 'remove attach'
    click_on 'Update Question'
    expect(page).not_to have_link 'spec_helper.rb'
  end
end