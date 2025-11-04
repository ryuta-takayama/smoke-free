class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?
  

 def after_sign_up_path_for(resource)
    dashbords_path(resource)
 end

 def after_sign_in_path_for(resource)
     dashbords_path(resource)
 end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username,password|
      username == ENV["BASIC_AUTH_USER2"] && password == ENV["BASIC_AUTH_PASSWORD2"]
   end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        :nickname,
        :age,
        :reason_to_quit,
        { smoking_setting_attributes: [
            :quit_start_date, # virtual attribute (converted to quit_start_datetime)
            :daily_cigarette_count,
            :cigarette_price_jpy,
            :cigarette_per_pack
          ]
        }
      ]
    )
  end

end
