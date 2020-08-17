require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Friendship' do
    it 'has many posts' do
      assc = User.reflect_on_association(:posts)
      expect(assc.macro).to eq :has_many
    end

    it 'has many comments' do
      assc = User.reflect_on_association(:comments)
      expect(assc.macro).to eq :has_many
    end

    it 'has many likes' do
      assc = User.reflect_on_association(:likes)
      expect(assc.macro).to eq :has_many
    end

    it 'has and belongs to many requested friends' do
      assc = User.reflect_on_association(:requested_friends)
      expect(assc.macro).to eq :has_and_belongs_to_many
    end

    it 'has and belongs to many requester friends' do
      assc = User.reflect_on_association(:requester_friends)
      expect(assc.macro).to eq :has_and_belongs_to_many
    end
  end

  context 'Actions' do
    before :each do
      @one = User.create(name: 'john', email: 'john@doe.com', password: 'password')
      @two = User.create(name: 'jane', email: 'jane@doe.com', password: 'password')
      @three = User.create(name: 'josh', email: 'josh@doe.com', password: 'password')
    end

    it 'sends a friendship request' do
      expect(@one.requested_friends.include?(@two)).to be false
      @one.request_friendship(@two)
      expect(@one.requested_friends.include?(@two)).to be true
    end

    it 'has access to pending sent friendship requests' do
      @one.request_friendship(@two)
      expect(@one.sent_requests.include?(@two)).to be true
    end

    it 'has access to pending received friendship requests' do
      @one.request_friendship(@two)
      expect(@two.received_requests.include?(@one)).to be true
    end

    it 'approves a friendship request' do
      @one.request_friendship(@two)
      @two.approve_requester(@one)
      expect(@two.friends.include?(@one)).to be true
    end

    it 'declines a friendship request' do
      @one.request_friendship(@two)
      @two.decline_requester(@one)
      expect(@two.declined_requests.include?(@one)).to be true
    end
  end
end
