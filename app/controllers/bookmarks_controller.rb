class BookmarksController < ApplicationController
  # ログインしていることを確認
  before_action :authenticate_user!

  # ブックマーク追加
  def create
    bookmark = current_user.bookmarks.create(restaurant_id: params[:restaurant_id])
    if bookmark.persisted?
      redirect_back fallback_location: root_path, notice: 'ブックマークに追加しました。'
    else
      redirect_back fallback_location: root_path, alert: 'ブックマークの追加に失敗しました。'
    end
  end

  # ブックアーク削除
  def destroy
    bookmark = current_user.bookmarks.find_by(restaurant_id: params[:restaurant_id])
    if bookmark&.destroy
      redirect_back fallback_location: root_path, notice: 'ブックマークを削除しました。'
    else
      redirect_back fallback_location: root_path, alert: 'ブックマークの削除に失敗しました。'
    end
  end

  def bookmarks
    @bookmarked_restaurants = current_user.bookmarks
  end
end
