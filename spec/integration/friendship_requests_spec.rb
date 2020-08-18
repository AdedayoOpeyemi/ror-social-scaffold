require_relative '../rails_helper'

RSpec.feature 'Friendship Requests', type: :feature do
  before :each do
    @user1 = User.create(name: 'User One', email: 'user1@mail.com', password: 'password')
    @user2 = User.create(name: 'User Two', email: 'user2@mail.com', password: 'password')

    visit new_user_session_path
    page.fill_in 'user[email]', with: 'user1@mail.com'
    page.fill_in 'user[password]', with: 'password'
    click_button 'Log in'
  end

  scenario 'Sending a friendship request', type: :feature do
    visit root_path
    expect(page).to have_link 'All users', href: users_path
    click_link 'All users', href: users_path
    expect(page).to have_link 'Request Friendship', href: request_friendship_url(@user2)
    click_link 'Request Friendship', href: request_friendship_url(@user2)

    expect(@user2.received_requests.include?(@user1)).to be true
  end
end
