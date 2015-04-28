require 'rails_helper'

RSpec.describe 'Authentication', type: :feature do
  describe 'login' do
    before(:each) do
      @user = User.create(username: 'username', password: '1234')
    end

    it 'success' do
      visit '/login'

      within('.login-form') do
        fill_in 'Username', with: 'username'
        fill_in 'Password', with: '1234'

        click_button 'Login'
      end
      expect(page).to have_content('Welcome')
    end

    it 'fail' do
      visit '/login'

      within('.login-form') do
        fill_in 'Username', with: 'username'
        fill_in 'Password', with: '123'

        click_button 'Login'
      end
      expect(page).to have_content('not found')
    end
  end
end