class SmokingCalculator
  def initialize(user)
    @user = user
    @s = user.smoking_setting
  end

  # 進行中セッションの開始時刻（まず abstinence_sessions、なければ設定値）
  def current_session_start
    ongoing = @user.abstinence_sessions&.where(ended_at: nil)&.order(:started_at)&.last
    return ongoing.started_at if ongoing&.started_at

    return @s.quit_start_datetime if @s&.respond_to?(:quit_start_datetime) && @s.quit_start_datetime.present?
    return @s.quit_start_date.to_time.in_time_zone if @s&.respond_to?(:quit_start_date) && @s.quit_start_date.present?
    nil
  end

  # ① 現在の禁煙「連続」日数（streak）
  def current_streak_days
    start = current_session_start
    return 0 unless start
    (Time.zone.today - start.to_date).to_i
  end

  # ② 禁煙節約額（円）… 1日コスト × 連続日数
  def saved_money_jpy
    return 0 unless daily_cost
    (daily_cost * current_streak_days).to_i
  end

  # ③ 禁煙本数（本）… 1日本数 × 連続日数
  def avoided_cigarettes
    return 0 unless @s&.daily_cigarette_count
    (@s.daily_cigarette_count.to_i * current_streak_days).to_i
  end

  private

  def daily_cost
    return nil unless @s&.cigarette_price_jpy && @s&.daily_cigarette_count
    pack_size = (@s.cigarette_per_pack.presence || 20).to_f
    packs_per_day = @s.daily_cigarette_count.to_f / pack_size
    packs_per_day * @s.cigarette_price_jpy.to_f
  end
end

