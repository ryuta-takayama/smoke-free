class DashboardsController < ApplicationController
 def index
    @user = current_user
    @calc = SmokingCalculator.new(@user)
    @session_start = @calc.current_session_start
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    @posts = @user.posts.where(created_at: today_range).order(created_at: :asc)
 end
end
