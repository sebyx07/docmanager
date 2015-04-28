require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'hashed password' do
    subject(:user){User.new}

    it 'has secure password' do
      user.password = '123'
      expect(user.password).to eq '123'
    end

    context 'no password' do
      it 'it gives nil, no password' do
        expect(user.password).to eq nil
      end
    end
  end
end
