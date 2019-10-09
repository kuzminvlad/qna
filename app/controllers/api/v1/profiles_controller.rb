class Api::V1::ProfilesController < Api::V1::BaseController
  skip_authorization_check
  
  def me
    respond_with current_resourse_owner
  end
end
