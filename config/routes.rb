Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api' do
  	scope '/v1' do
			scope '/projects' do

	    	post '/register' => 'users#register'
	    	post '/login' => 'users#login'
	    	post '/location' => 'users#location'
	    	post '/logout' => 'users#logout'
	    
	    end
	  end
	end

end
