class DashboardsController < ApplicationController
 def index
    @user = current_user
    @calc = SmokingCalculator.new(@user)
    @session_start = @calc.current_session_start
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    @posts = @user.posts.where(created_at: today_range).order(created_at: :asc)
    prepare_goal_metrics
 end

  private

  def prepare_goal_metrics
    @current_goal = current_user.goal
    return unless @current_goal

    @goal_item = @current_goal.target_item
    @goal_target_amount = @current_goal.target_amount_jpy.to_i

    daily_saving = daily_saving_amount
    @goal_daily_saving = daily_saving

    if daily_saving.present? && daily_saving.positive? && @current_goal.started_on.present?
      elapsed_days = [(Time.zone.today - @current_goal.started_on.to_date).to_i, 0].max
      saved = daily_saving * elapsed_days
      @goal_saved_jpy = saved

      remaining = [@goal_target_amount - saved, 0].max
      @days_left = remaining.zero? ? 0 : (remaining.to_f / daily_saving).ceil

      progress = (@goal_target_amount.positive? ? (saved.to_f / @goal_target_amount) * 100 : 0)
      @goal_progress_rate = progress > 999 ? 999 : progress.round(progress >= 100 ? 0 : 1)
      @goal_achieved = progress >= 100
    else
      @goal_saved_jpy = 0
      @days_left = nil
      @goal_progress_rate = nil
      @goal_achieved = false
    end
  end

  def daily_saving_amount
    s = current_user.smoking_setting
    return nil unless s&.cigarette_price_jpy && s&.daily_cigarette_count

    pack_size = (s.cigarette_per_pack.presence || 20).to_f
    packs_per_day = s.daily_cigarette_count.to_f / pack_size
    (packs_per_day * s.cigarette_price_jpy.to_f).to_i
  end
end
