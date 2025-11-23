class AccountSettingsController < ApplicationController
  before_action :set_user

  def show
    @calc = SmokingCalculator.new(@user) if @user.smoking_setting
  end

  def update
    if @user.update(account_settings_params)
      redirect_to dashboards_path, notice: "設定を保存しました"
    else
      @calc = SmokingCalculator.new(@user) if @user.smoking_setting
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
    @user.build_smoking_setting unless @user.smoking_setting
  end

  def account_settings_params
    params.require(:user).permit(
      :nickname,
      :email,
      :password,
      :password_confirmation,
      :reason_to_quit,
      smoking_setting_attributes: [
        :id,
        :quit_start_date,
        :daily_cigarette_count,
        :cigarette_price_jpy,
        :cigarette_per_pack
      ]
    )
  end
end
