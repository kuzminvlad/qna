require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #github' do
    context 'user dont exist yet' do
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'user@email.com' })
        get :github
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end

      it { should be_user_signed_in }
    end

    context 'found user without authorization' do
      before do
        user
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email })
        get :github
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end

      it { should be_user_signed_in }
    end

    context 'found user with authorization' do
      let(:auth) { create(:authorization, user: user) }

      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new(provider: auth.provider, uid: auth.uid, info: { email: user.email })
        get :github
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end

      it { should be_user_signed_in }
    end
  end
end
