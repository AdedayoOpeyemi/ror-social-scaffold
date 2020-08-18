require_relative '../rails_helper'
RSpec.feature 'Timeline Posts', type: :feature do
  before :each do
    @user1 = User.create(name: 'User One', email: 'user1@mail.com', password: 'password')
    @user2 = User.create(name: 'User Two', email: 'user2@mail.com', password: 'password')
    @user3 = User.create(name: 'User Three', email: 'user3@mail.com', password: 'password')

    visit new_user_session_path
    page.fill_in 'user[email]', with: 'user1@mail.com'
    page.fill_in 'user[password]', with: 'password'
    click_button 'Log in'
  end

  scenario 'User can view posts of friends on Timeline', type: :feature do
    visit root_path
    @user2.request_friendship(@user1)
    @post = @user2.posts.create(content: 'user2 new post')
    @user1.approve_requester(@user2)
    expect(page).to have_link 'Timeline', href: posts_path
    click_link 'Timeline', href: posts_path
    expect(page).to have_text 'user2 new post'
    expect(page).to have_link 'Like!', href: post_likes_path(@post)
  end

  scenario 'User cannot view post of non-friends on Timeline', type: :feature do
    visit root_path
    @post = @user3.posts.create(content: 'user3 new post')
    expect(page).to have_link 'Timeline', href: posts_path
    click_link 'Timeline', href: posts_path
    expect(page).not_to have_text 'user3 new post'
    expect(page).not_to have_link 'Like!', href: post_likes_path(@post)
  end
end
