class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save

    else
      render 'new'
    end
  end
  def user_params
    params.require(:user).permit(:name, :email,
      :password, :password_confirmation)
  end

  def show
    @user = User.find(params[:id])
    # ターミナルでのデバッグ
    # debugger
  end
end
