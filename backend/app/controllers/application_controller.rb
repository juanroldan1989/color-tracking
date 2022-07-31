class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # Add a before_action to authenticate all requests.
  # Move this to subclassed controllers if you only
  # want to authenticate certain methods.
  before_action :authenticate

  private

  # Authenticate the user with token based authentication
  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    Rails.logger.info "authenticate_token!"
    authenticate_with_http_token do |token, options|
      Rails.logger.info "authenticate_token - token: #{token}"
      @user = User.find_by(api_key: token)

      Rails.logger.info "authenticate_token - @user: #{@user.inspect}"

      if @user.present?
        @user
      else
        render_unauthorized
      end
    end
  end

  def render_unauthorized(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")

    render json: { status: :error, message: "Bad credentials" }, status: :unauthorized
  end
end
