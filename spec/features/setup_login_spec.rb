require 'rails_helper'

feature 'Setup and Login' do

  scenario 'Setup a new User' do
    visit setup_path

    fill_in 'user_email', with: 'user@happyfeed.tld'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'

    click_button 'Create User'

    expect(User.first.email).to eq 'user@happyfeed.tld'
  end

  scenario 'Redirect from Setup if a User exists' do
    FactoryGirl.create(:user)

    visit setup_path

    expect(page).not_to have_content 'Setup'
  end

  scenario 'Login as User' do
    FactoryGirl.create(:user)

    visit login_path

    fill_in 'login_email', with: 'user@happyfeed.tld'
    fill_in 'login_password', with: 'password'

    click_button 'Login'

    within '.header' do
      expect(page).to have_content 'user@happyfeed.tld'
    end
  end

  scenario 'Login as User' do
    FactoryGirl.create(:user)

    visit login_path

    fill_in 'login_email', with: 'user@happyfeed.tld'
    fill_in 'login_password', with: 'password'

    click_button 'Login'

    click_link 'logout'

    within '.header' do
      expect(page).not_to have_content 'user@happyfeed.tld'
    end
  end

end
