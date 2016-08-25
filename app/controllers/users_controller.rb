class UsersController < ApplicationController
	before_action :authenticate, except: [:register, :login, :location, :get_location ]
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
		
		@user = User.find_by(username: user_params[:username])
		password = Digest::SHA1.hexdigest(user_params[:password])
		# if @user.username == user_params[:username]
		if @user.encrypted_password == password
			render json: { status: 'success', code: 200, data: @user,
                   message: 'User logged in successfully'} 
    else
    	render json: { status: 'error', code: 400, data: @user,
                   message: 'User doesnt exist'} 
    end
	end

	def location
		@user = User.find_by(params[:id])
		if @user.update_attributes(latitude: user_params[:latitude], longitude: user_params[:longitude])
			render json: { status: 'success', code: 200, data: @user,
                 message: 'Location updated'} 
		else
			render json: { status: 'error', code: 400, data: @user.errors.full_messages,
                 message: 'Error, location not saved'}
    end 
	end

	def get_location
		if @user = User.find_by(params[:id])
			@lat = @user.latitude
			@lon = @user.longitude
			render json: { status: 'success', code: 200, data: {latitude: @lat, longitude: @lon},
                 message: 'Location returned successfully'} 
    else
    	render json: { status: 'error', code: 400, data: @user.errors.full_messages,
                 message: 'Error, location not returned'}
    end 

	end

	def logout
		@user = User.find_by(params[:id])
		@user.access_token = nil
		if @user.access_token.save
			render json: { status: 'success', code: 200, data: nil,
	                message: 'Logged out successfully'} 
    else
    	render json: { status: 'error', code: 400, 
	                message: 'Logged out error'} 
    end
	end

	private
	def user_params
		params.require( :user ).permit( :username, :password, :longitude, :latitude )
	end

	# protected
	# def authenticate
 #  	authenticate_or_request_with_http_token do |token, options|
 #  		User.find_by(auth_token: token)
	# 	end
	# end

	protected
  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      User.find_by(auth_token: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { message:'Bad credentials', status: 401 }
  end

end


# {
#     "user": {
#         "username": "123",
#         "password": "qwef"
        
#     }
# }
