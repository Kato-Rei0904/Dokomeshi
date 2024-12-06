class UsersController < ApplicationController
  before_action :authenticate_user!  # ログインしていることを確認

  def mypage
    # ユーザー情報を表示
    @user = current_user
  end

end
