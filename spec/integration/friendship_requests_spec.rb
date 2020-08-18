require_relative '../rails_helper'

# rubocop:disable Metrics/BlockLength
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

  scenario 'Viewing frienship request', type: :feature do
    @user2.request_friendship(@user1)
    visit root_path
    expect(page).to have_link 'Friendship requests', href: friendship_requests_path
    click_link 'Friendship requests', href: friendship_requests_path
    expect(page).to have_link 'See Profile', href: user_path(@user2)
  end

  scenario 'Accepting a frienship request', type: :feature do
    visit root_path
    @user2.request_friendship(@user1)
    expect(page).to have_link 'Friendship requests', href: friendship_requests_path
    click_link 'Friendship requests', href: friendship_requests_path
    expect(page).to have_link 'Accept', href: approve_request_path(@user2)
    click_link 'Accept', href: approve_request_path(@user2)
    expect(@user1.friends.include?(@user2)).to be true
  end

  scenario 'Rejecting a frienship request', type: :feature do
    visit root_path
    @user2.request_friendship(@user1)
    expect(page).to have_link 'Friendship requests', href: friendship_requests_path
    click_link 'Friendship requests', href: friendship_requests_path
    expect(page).to have_link 'Reject', href: decline_request_path(@user2)
    click_link 'Reject', href: decline_request_path(@user2)
    expect(@user1.declined_requests.include?(@user2)).to be true
  end
end
# rubocop:enable Metrics/BlockLength
