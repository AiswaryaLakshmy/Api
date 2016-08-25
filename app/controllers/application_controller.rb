class ApplicationController < ActionController::API
	include ActionController::HttpAuthentication::Token::ControllerMethods

	# protected
	# def authenticate_or_request_with_http_token(realm = "Application")
	# 	debugger
	#   self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
	#   render :json => {:error => "HTTP Token: Access denied."}, :status => :unauthorized
	# end

end
