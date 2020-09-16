class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
      flash[:success] = "Welcome to the Sample App!"
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
end
