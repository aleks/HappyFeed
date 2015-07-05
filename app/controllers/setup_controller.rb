class SetupController < ApplicationController

  def setup
    redirect_to root_path if User.any?

    @user = User.new
    if request.post?
      @user.attributes = setup_params.merge(auth_token: build_auth_token(setup_params[:email], setup_params[:password]))
      if @user.save
        login_user @user
        redirect_to feeds_path
      end
    end
  end

  private

    def setup_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def build_auth_token(email, password)
      Digest::MD5.hexdigest(email + ':' + password)
    end

end
