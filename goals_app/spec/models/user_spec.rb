require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(username: 'my_user', password: '123123') }
  
  describe User do
    
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) }
    it { should validate_length_of(:password).is_at_least(6) }
    
    describe '::find_by_credentials' do 
      before (:each) do
        user.save
      end
      
      it 'finds the correct user/password combination' do 
        found_user = User.find_by_credentials('my_user', '123123')
        expect(found_user).to eq(user)
      end
      
      it 'doesn\'t find user with incorrect password' do
        found_user = User.find_by_credentials('my_user', '234234')
        expect(found_user).to be_nil
      end
      
      it 'returns nil if user doesn\'t exist' do 
        found_user = User.find_by_credentials('different_user', '123123')
        expect(found_user).to be_nil
      end
    end
  end
  
  describe '#ensure_session_token' do
    it 'sets user session token if it does not exist' do
      user.session_token = nil
      user.ensure_session_token
      expect(user.session_token).to_not be_nil
    end
    
    it 'does not overwrite session token if it exists' do
      token = user.session_token
      user.ensure_session_token
      expect(user.session_token).to eq(token)
    end
  end
  
  describe '#reset_session_token!' do
    it 'changes and persists the session token' do
      token = user.session_token
      user.reset_session_token!
      expect(User.find_by(username: user.username).session_token).to_not eq(token)
    end
  end
  
  describe '#password=' do
    it 'sets user\'s password_digest' do
      password_digest = user.password_digest
      user.password = '234234'
      expect(user.password_digest).to_not eq(password_digest)
    end
    
    it 'does not save to database' do
      new_user = User.create(username: 'other_user', password: '234234')
      found_user = User.find_by(username: 'other_user')
      expect(found_user.password).to be_nil
    end
  end
end
