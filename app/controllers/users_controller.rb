class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :ensure_current_user,only:[:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "登録が完了しました！"
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @pictures = @user.pictures

    favorites = Favorite.where(user_id: current_user.id).pluck(:picture_id)
    @favorite_list = Picture.find(favorites)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "情報を編集しました！"
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to new_user_path, notice:"ユーザー情報を削除しました！"
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end
end

