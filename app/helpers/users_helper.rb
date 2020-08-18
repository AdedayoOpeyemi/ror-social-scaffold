module UsersHelper
  def friendship_request_link(user)
    not_friend = current_user.not_friend_with?(user)

    return unless not_friend && current_user != user

    link_to 'Request Friendship', request_friendship_url(user), class: 'profile-link', method: :post
  end
end
