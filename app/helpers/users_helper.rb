module UsersHelper
  def friendship_request_link(user)
    not_friend = current_user.not_friend_with?(user)
    
    link_to 'Request Friendship', request_friendship_url(user), class: 'profile-link', method: :post if not_friend && current_user != user
  end
end
