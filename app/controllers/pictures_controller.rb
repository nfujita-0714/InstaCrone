class PicturesController < ApplicationController
  before_action :set_picture, only: %i[show edit update destroy]
  before_action :authenticate_user, only: [:edit, :update, :destroy]

  def index
    @pictures = Picture.all
  end

  def show
    if logged_in?
      @favorite = current_user.favorites.find_by(picture_id: @picture.id)
    else
      redirect_to new_user_path, notice:"ログインが必要です"
    end
  end

  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end

  def edit
  end

  def create
    # @picture = Picture.new(picture_params)
    @picture = current_user.pictures.build(picture_params)
    if params[:back]
      render :new
    else
      if @picture.save
        PictureMailer.picture_mail(@picture).deliver
        redirect_to pictures_path, notice:"Picture was successfully created."
      else
        render :new
      end
    end
  end

  def update
    if @picture.update(picture_params)
      redirect_to pictures_path, notice:"ブログを編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path, notice:"ブログを削除しました！"
  end

  def confirm
    @picture = Picture.new(picture_params)
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  private
  def set_picture
  @picture = Picture.find(params[:id])
  end

  def picture_params
  params.require(:picture).permit(:title, :content, :user_id, :image, :image_cache)
  end

  def ensure_user
  @pictures = current_user.pictures
  @picture = @pictures.find_by(id: params[:id])
  redirect_to new_picture_path unless @picture
  end  
end