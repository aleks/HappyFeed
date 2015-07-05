require 'rails_helper'

feature 'Groups Mangement' do

  before(:each) do
    @user = FactoryGirl.create(:user)

    visit login_path
    fill_in 'login_email', with: 'user@happyfeed.tld'
    fill_in 'login_password', with: 'password'
    click_button 'Login'
  end

  scenario 'Add a Group' do
    visit groups_path

    expect(page).to have_content 'Default Group'

    fill_in 'group_title', with: 'My New Group'

    click_button 'Create Group'

    expect(page).to have_content 'My New Group'
    expect(User.find(@user.id).groups.last.title).to eq 'My New Group'
  end

  scenario 'Edit a Group' do
    visit groups_path

    expect(page).to have_content 'Default Group'

    click_link 'edit'

    expect(page).to have_content 'Edit Group'

    fill_in 'group_title', with: 'New Default Group'

    click_button 'Update Group'

    expect(page).to have_content 'New Default Group'
    expect(User.find(@user.id).groups.last.title).to eq 'New Default Group'
  end

  scenario 'Default Group has no "Delete this Group" Link' do
    visit groups_path

    expect(page).to have_content 'Default Group'

    click_link 'edit-group-1'

    expect(page).to have_content 'Edit Group'
    expect(page).not_to have_content 'Delete this Group'
  end

  scenario 'Delete a Group' do
    group = FactoryGirl.create(:group, title: 'New Random Group', default: false)

    visit edit_group_path(group.id)

    expect(page).to have_content 'Edit Group'

    click_link 'Delete this Group'

    expect(page).not_to have_content 'New Random Group'
  end

end
