class AuthController < ApplicationController

  def login
    if request.post? && @user = User.find_by(email: params[:login][:email])
      if @user.authenticate(params[:login][:password])
        login_user @user
        redirect_to feeds_path
      end
    end
  end

  def logout
    logout_user
    redirect_to login_path
  end

end
