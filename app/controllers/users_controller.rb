class UsersController < ApplicationController
  def index
    @users ||= User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.is_active = false if @user.plan.stripe_id.nil?
    if @user.save
      session[:user_id] = @user.id
      redirect_to my_account_path, notice: "Thank you for signup"
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :plan_id)
  end
end
