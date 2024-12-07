require 'net/http'
require 'json'

class RestaurantsController < ApplicationController

  # ホーム画面
  def home_index
    
    # 緯度と経度を数値として取得
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f

    # デフォルトの検索パラメータ
    range = 2 # 半径2km
    count = 10 # 10件まで
    
    api_key = ENV['HOTPEPPER_API_KEY']

    # APIリクエスト
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{api_key}&lat=#{latitude}&lng=#{longitude}&range=#{range}&count=#{count}&format=json"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    @restaurants = data['results']['shop'].map do |restaurant|
      # 店舗の緯度経度を取得
      shop_latitude = restaurant['lat'].to_f
      shop_longitude = restaurant['lng'].to_f

      # Geocoderで距離計算 (km単位)
      distance = Geocoder::Calculations.distance_between(
        [latitude, longitude], [shop_latitude, shop_longitude]
      )

      # 店舗情報に距離を追加
      restaurant.merge('distance' => distance.round(2))
    end

    @results_available = data['results']['results_available'].to_i
    @results_returned = data['results']['results_returned'].to_i
  end

  # 店舗検索
  def search

    # 検索条件をセッションに保存
    session[:search_params] = params.slice(:latitude, :longitude, :range, :freeword, :start)

    latitude = params[:latitude]
    longitude = params[:longitude]
    range = params[:range] || 3  # 検索する範囲(デフォルト3の1km)
    keyword = params[:keyword]   # フリーワードパラメータを追加
    count = params[:count] || 10 # 表示件数
    start = params[:start].to_i || 1

    # APIキーの設定
    api_key = ENV['HOTPEPPER_API_KEY']
    
    # APIリクエストURLの構築
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    query = {
      key: api_key,
      lat: latitude,
      lng: longitude,
      range: range,
      count: count,
      start: start,
      format: 'json'
    }

    # キーワードが指定されている場合、クエリに追加
    query[:keyword] = keyword if keyword.present?

    # URIを生成
    uri = URI(url)
    uri.query = URI.encode_www_form(query)
    Rails.logger.info "HotPepper API Request URL: #{uri}" # ログにリクエストURLを出力

    # APIリクエスト送信
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    # レスポンスのデータを処理
    @restaurants = data['results']['shop']
    @results_available = data['results']['results_available'].to_i
    @results_returned = data['results']['results_returned'].to_i
    @current_start = start

    # 現在のお気に入り店舗を取得
    @bookmarked_restaurants = session[:bookmarked_restaurants] || []
    # データが正しく取得されているか確認
    if data['results'] && data['results']['shop'].present?
      @restaurant = data['results']['shop'].first
    else
      @restaurant = nil
    end

    respond_to do |format|
      format.html
      # 他のフォーマットをサポートする場合
      format.json { render json: @data }
    end
  end

  # 店舗の詳細
  def show
    restaurant_id = params[:id]
    api_key = ENV['HOTPEPPER_API_KEY']
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{api_key}&id=#{restaurant_id}&format=json"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    @restaurant = data['results']['shop'].first
  end

  
end
