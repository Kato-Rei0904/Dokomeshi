class ApplicationController < ActionController::Base
  # rails8.0~ allow_browserが使用されている
  before_action :allow_browser

  private 

  # allow_browserが許可するブラウザの設定
  def allow_browser(versions: {}, block: false)
    allowed_browsers = ["Chrome", "Safari", "Firefox"]
    user_agent = request.user_agent || ""
    
    # エラー時の表示
    unless allowed_browsers.any? { |browser| user_agent.include?(browser) }
      render file: "public/406-unsupported-browser.html", status: :not_acceptable
    end
  end

  
  # Webp画像、Webプッシュ、バッジ、インポートマップ、CSSネスティング、CSS :hasをサポートするモダンブラウザのみ許可
  allow_browser versions: :modern

  # ログイン確認
  before_action :authenticate_user!
end
