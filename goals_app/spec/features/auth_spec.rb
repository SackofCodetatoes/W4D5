require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do
  scenario 'has a new user page' do 
    visit new_user_url
    expect(page).to have_content 'Sign up'
  end
    
  feature 'signing up a user' do
    before(:each) do
      visit new_user_url
      fill_in 'username', with: 'test_user'
      fill_in 'password', with: '123123'
      click_on 'Create Account'
    end
    
    scenario 'shows username on the show page after signup' do 
      expect(page).to have_content 'test_user'
    end
  end
end

feature 'logging in' do
  let(:user) { User.create(username: 'test_user', password: '123123') } 
  scenario 'shows username on the homepage after login' do 
    visit new_session_url
    # p user
    fill_in 'username', with: "test_user"
    fill_in 'password', with: "123123"
    click_on 'Log In'
    expect(page).to have_content 'test_user'
  end
  
end

feature 'logging out' do
  scenario 'begins with a logged out state' do
    expect(logged_in?).to be_false
  end
  

  scenario 'doesn\'t show username on the homepage after logout'

end