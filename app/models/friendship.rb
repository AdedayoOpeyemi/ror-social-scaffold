class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

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
