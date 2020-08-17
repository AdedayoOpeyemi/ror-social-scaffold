class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :requested_friends,
                          class_name: 'User',
                          foreign_key: 'requester_id',
                          association_foreign_key: 'requestee_id',
                          join_table: 'friendships'

  has_and_belongs_to_many :requester_friends,
                          class_name: 'User',
                          foreign_key: 'requestee_id',
                          association_foreign_key: 'requester_id',
                          join_table: 'friendships'

  def friends
    (
      requested_friends.where("friendships.status = 'approved'") +
      requester_friends.where("friendships.status = 'approved'")
    ).uniq
  end

  def received_requests
    requester_friends.where("friendships.status =  'pending'")
  end

  def sent_requests
    requested_friends.where("friendships.status = 'pending'")
  end

  def declined_requests
    requester_friends.where("friendships.status =  'declined'")
  end

  def request_friendship(friend)
    requested = requested_friends.include?(friend)
    requester = requester_friends.include?(friend)

    unless requested || requester
      requested_friends << friend
      return true
    end

    false
  end

  def approve_requester(requester)
    friendship = Friendship.where(requestee_id: id, requester_id: requester.id).first
    if friendship
      friendship.approve
      return true
    end

    false
  end

  def decline_requester(requester)
    friendship = Friendship.where(requestee_id: id, requester_id: requester.id).first
    if friendship
      friendship.decline
      return true
    end

    false
  end
end
