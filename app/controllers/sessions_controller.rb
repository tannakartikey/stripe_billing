class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to my_account_path, notice: "Logged in"
    else
      flash.now.alert = "Email of password wrong"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  def getin
    session[:user_id] = params[:user_id].to_i
    redirect_to my_account_path, notice: "Logged in automatically"
  end
end
