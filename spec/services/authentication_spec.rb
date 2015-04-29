require 'rails_helper'

RSpec.describe UserAuthenticationService do
  let(:user){User.new(password: '123')}
  subject(:auth){ UserAuthenticationService.instance }

  describe '#authenticate' do
    it 'correct password' do
      expect(auth.authenticate(user, '123')).to be true
    end
  end
end