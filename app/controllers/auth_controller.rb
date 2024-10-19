class AuthController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def register
      user = User.new(user_params)
      if user.save
        render json: { message: 'User created' }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def login
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = encode_token(user.id)
        render json: { token: token }, status: :ok
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
  
    def encode_token(user_id)
      JWT.encode({ user_id: user_id }, 'your_secret_key', 'HS256')
    end

end
  