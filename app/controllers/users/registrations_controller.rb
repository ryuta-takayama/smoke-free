class Users::RegistrationsController < Devise::RegistrationsController
  # GET /resource/sign_up
  def new
    build_resource({})
    resource.build_smoking_setting unless resource.smoking_setting
    respond_with resource
  end
end
