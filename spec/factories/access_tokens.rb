FactoryBot.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    resource_owner_id { create(:user).id }
    application { create(:oauth_application) }
  end
end
