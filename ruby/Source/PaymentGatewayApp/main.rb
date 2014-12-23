require 'sinatra'
require 'json'
set :port => 2345
get '/' do
	"Payment GateWay"
end
post '/payment' do
	@request = request
	erb :payment_form
end
post '/pay' do
	if (Random.rand 1..10 ) == 6 
		@request = request
		@error = true
		erb :payment_form
	else
		redirect to("http://localhost:1234/payment_done/#{request['order_id']}")
	end
end