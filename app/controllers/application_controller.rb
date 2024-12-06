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

  
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
end
