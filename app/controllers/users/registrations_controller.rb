class Users::RegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      persist_smoking_setting(resource)

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def persist_smoking_setting(user)
    return unless params[:smoking_setting].present?

    sp = params.require(:smoking_setting).permit(:quit_start_date, :daily_cigarette_count, :cigarette_price_jpy, :cigarette_per_pack)

    # 必須が揃っていない場合は作成をスキップ（サインアップ自体は成功させる）
    required_present = sp[:quit_start_date].present? && sp[:daily_cigarette_count].present? && sp[:cigarette_price_jpy].present?
    return unless required_present

    quit_dt = begin
      # date(YYYY-MM-DD) をアプリのタイムゾーンの 00:00 に変換
      Date.parse(sp[:quit_start_date]).in_time_zone.beginning_of_day
    rescue ArgumentError, TypeError
      Time.zone.now.beginning_of_day
    end

    per_pack = (sp[:cigarette_per_pack].presence || 20).to_i

    SmokingSetting.create!(
      user: user,
      daily_cigarette_count: sp[:daily_cigarette_count].to_i,
      cigarette_price_jpy: sp[:cigarette_price_jpy].to_i,
      cigarette_per_pack: per_pack,
      quit_start_datetime: quit_dt
    )
  rescue ActiveRecord::RecordInvalid => e
    # 失敗してもユーザー登録は成功させ、エラーメッセージだけ足す
    user.errors.add(:base, "禁煙情報の保存に失敗しましたが、ユーザー登録は成功しました！マイページで禁煙情報を設定してください: #{e.record.errors.full_messages.to_sentence}")
  end
end

