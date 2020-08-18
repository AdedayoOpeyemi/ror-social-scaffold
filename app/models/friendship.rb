class Friendship < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  belongs_to :requestee, class_name: 'User'

  def approve
    self.status = 'approved'
    save

    true
  end

  def decline
    self.status = 'declined'
    save

    true
  end
end
