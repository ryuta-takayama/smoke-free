class DashboardsController < ApplicationController
 def index
    @user = current_user
    @calc = SmokingCalculator.new(@user)
    @session_start = @calc.current_session_start
    @posts = @user.posts.order(created_at: :asc)
 end
end
