class GoalsController < ApplicationController
  before_action :set_goal, only: [:new,:create]
  before_action :set_calculator, only: [:new,:create]
  before_action :assign_metrics, only:  [:new,:create]

  def new
  end

  def create
    @goal.assign_attributes(goal_params)
    @goal.achieved_on = estimate_achieved_on(@goal.target_amount_jpy, @daily_saving_amount) || @goal.started_on

    if @goal.save
      redirect_to dashboards_path, notice: "目標を設定しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_goal
    # Default to today so the date field is pre-filled
    @goal = current_user.build_goal(started_on: Time.zone.today)
  end

  def set_calculator
    @calc = SmokingCalculator.new(current_user) if current_user.smoking_setting.present?
  end

  # Prepares numbers for the right-hand summary cards
  def assign_metrics
    @daily_saving_amount = daily_saving_amount
    @skipped_cigarettes_per_day = current_user.smoking_setting&.daily_cigarette_count
    @days_to_goal = days_to_goal(@goal.target_amount_jpy, @daily_saving_amount)
    @goal_progress_rate = progress_rate(@goal.target_amount_jpy)
  end

  def daily_saving_amount
    s = current_user.smoking_setting
    return nil unless s&.cigarette_price_jpy && s&.daily_cigarette_count

    pack_size = (s.cigarette_per_pack.presence || 20).to_f
    packs_per_day = s.daily_cigarette_count.to_f / pack_size
    (packs_per_day * s.cigarette_price_jpy.to_f).to_i
  end

  def days_to_goal(target_amount, daily_amount)
    return nil if target_amount.blank? || daily_amount.blank? || daily_amount <= 0

    (target_amount.to_f / daily_amount).ceil
  end

  def progress_rate(target_amount)
    return nil if target_amount.blank? || @calc.nil?

    saved = @calc.saved_money_jpy
    return nil if saved.zero?

    (((saved / target_amount.to_f) * 100).round(1)).clamp(0, 999)
  end

  def estimate_achieved_on(target_amount, daily_amount)
    return nil if @goal.started_on.blank?

    days = days_to_goal(target_amount, daily_amount)
    @goal.started_on + days.days if days
  end

  def goal_params
    params.require(:goal).permit(:target_item, :target_amount_jpy, :started_on)
  end
end
