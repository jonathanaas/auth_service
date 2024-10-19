class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def authenticate_user!
    token = request.headers['Authorization']
    decoded = JWT.decode(token, 'your_secret_key', true, { algorithm: 'HS256' })
    @current_user = User.find(decoded[0]['user_id'])
  rescue
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
  
end
