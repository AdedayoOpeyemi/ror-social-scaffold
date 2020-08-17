require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'Associations' do
    it 'belongs to a requester' do
      assc = Friendship.reflect_on_association(:requester)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to a requestee' do
      assc = Friendship.reflect_on_association(:requestee)
      expect(assc.macro).to eq :belongs_to
    end
  end

  context 'Actions' do
    before :each do
      @one = User.create(name: 'john', email: 'john@doe.com', password: 'password')
      @two = User.create(name: 'jane', email: 'jane@doe.com', password: 'password')
      @one.request_friendship(@two)
      @friendship = Friendship.first
    end

    it 'approves a friendship' do
      @friendship.approve
      expect(@friendship.status).to eq 'approved'
    end

    it 'decline a friendship' do
      @friendship.decline
      expect(@friendship.status).to eq 'declined'
    end
  end
end
