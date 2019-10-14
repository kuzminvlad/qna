require 'rails_helper'

describe 'Profile API' do
    
  it_behaves_like 'API Authenticable'

  context 'autorized' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before do
      get '/api/v1/profiles/me',
          params: { format: :json, access_token: access_token.token }
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    %w[id email created_at updated_at].each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
      end
    end

    %w[password encrypted_password].each do |attr|
      it "does not contain #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end

  def do_request(options = {})
    get '/api/v1/profiles/me', params: { format: :json }.merge(options)
  end
end
