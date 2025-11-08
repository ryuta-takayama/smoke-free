class DashboardsController < ApplicationController
 def show
    @user = current_user
    @calc = SmokingCalculator.new(@user)
    @session_start = @calc.current_session_start
 end
end
