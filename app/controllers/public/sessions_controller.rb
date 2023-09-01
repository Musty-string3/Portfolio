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
    user_path(current_user)
  end
  
  protected
  
  
  def user_status   #退会しているかを判断するメソッド
    @user = User.find_by(email: params[:user][:email])          
      #入力されたemailからアカウントを1件取得
    return if !@user                                            
      # アカウントを取得できなかった場合、メソッドを終了する
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted 
      #取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別 & is_deletedの値がtrueの場合
      redirect_to new_user_session_path, notice: "お客様は退会済みです。申し訳ございませんが、別のメールアドレスをお使いください。"
    end
  end
  
end
