class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@sample.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      # SecureRandom.urlsafe_base64はランダム文字列
      user.last_name = ""
      user.first_name = ""
      user.name = "ゲストユーザー"
      user.introduction = "こちらはゲストユーザーです。"
    end
    sign_in user
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました。"
  end
end
