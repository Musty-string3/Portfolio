# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :user_status, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    flash[:notice] = "#{current_user.name}さんでログインしました"
    user_path(current_user)
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  protected

  # 退会しているか？
  def user_status
    @user = User.find_by(email: params[:user][:email])
    return if !@user
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted
      redirect_to new_user_session_path, notice: "お客様は退会済みです。申し訳ございませんが、別のメールアドレスをお使いください。"
    end
  end

end
