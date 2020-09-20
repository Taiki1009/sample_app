class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # "/users/#{@user.id}"に redirectする
      redirect_to @user
    else
      render 'new'
    end
  end
  def user_params
    # 必須：require  許可：permit
    params.require(:user).permit(:name, :email,
      :password, :password_confirmation)
  end

  def show
    @user = User.find(params[:id])
    # ターミナルでのデバッグ
    # debugger
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
