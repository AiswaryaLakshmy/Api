class UsersController < ApplicationController
	before_action :restrict_access, except: [:register, :login]
	# skip_before_action :authenticate, only: [ :register, :login ]

	def register
		if User.where(username: user_params[:username]).present?
			render json: { status: 'error', code: 400, data: @user,
                   message: 'User already exists'} 
		else
			@user = User.new(user_params)
			password = Digest::SHA1.hexdigest(params[:user][:password])
			@user.encrypted_password = password
			@user.save
			render json: { status: 'success', code: 200, data: @user,
                   message: 'User registered successfully'} 
		end
	end

	def login
		
		password = Digest::SHA1.hexdigest(user_params[:password])
		@user = User.find_by(username: user_params[:username])
		# if @user.try(:username) == user_params[:username]
		if @user.try(:encrypted_password) == password
			render json: { status: 'success', code: 200, data: @user,
                   message: 'User logged in successfully'} 
    else
    	render json: { status: 'error', code: 400, data: @user,
                   message: 'User doesnt exist'} 
    end
	end

	def location
		if @current_user.update_attributes(latitude: user_params[:latitude], longitude: user_params[:longitude])
			render json: { status: 'success', code: 200, data: @user,
                 message: 'Location updated'} 
		else
			render json: { status: 'error', code: 400, data: @user.errors.full_messages,
                 message: 'Error, location not saved'}
    end 
	end

	def logout
		# binding.pry
		@current_user.access_token = nil
		if @current_user.access_token.save
			render json: { status: 'success', code: 200, data: nil,
	                message: 'Logged out successfully'} 
    else
    	render json: { status: 'error', code: 400, 
	                message: 'Logged out error'} 
    end
	end
# data: @user.errors.full_messages,
	private
	def user_params
		params.require( :user ).permit( :username, :password, :longitude, :latitude )
	end

	def restrict_access
  	authenticate_or_request_with_http_token do |token, options|
    	ApiKey.exists?(access_token: token)
  	end
	end

end

# protected
  # def authenticate
  	# controller.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
  	# controller.__send__ :render, :text => "HTTP Token: Access denied.\n", :status => :unauthorized
  	# binding.pry
  	# debugger
    # authenticate_or_request_with_http_token('Premium') do |token, options|
      # User.find_by(auth_token: token)
    # end
  # end
	# protected
  # def authenticate
  # 	# binding.pry
  #   authenticate_token || render_unauthorized
  # end

  # def authenticate_token
  #   authenticate_with_http_token do |token, options|
  #     User.find_by(auth_token: HTTP_AUTH_TOKEN)
  #   end
  # end

  # def render_unauthorized
  #   self.headers['WWW-Authenticate'] = 'Token realm="Application"'
  #   render json: {message: 'Bad credentials', status: 401}
  # end

# {
#     "user": {
#         "username": "123",
#         "password": "qwef"
        
#     }
# }
# protected
  # def authenticate
  	# controller.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
  	# controller.__send__ :render, :text => "HTTP Token: Access denied.\n", :status => :unauthorized
  	# binding.pry
  	# debugger
    # authenticate_or_request_with_http_token('Premium') do |token, options|
      # User.find_by(auth_token: token)
    # end
  # end
