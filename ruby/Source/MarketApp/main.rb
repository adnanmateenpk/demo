require 'sinatra'
require './config/database'
require './models/customer'
require './models/product'
require './models/order'
require './models/order_line'
require './models/admin_user'
require 'date'
require 'json'
require 'json/ext'

enable :sessions
set :port => 1234
get '/' do
	@flash = session["message"]
	session["message"] =nil
	erb :index
end
get '/customer' do
	
	@customer = Customer.new
	erb :customer_new
end
post '/customer' do
	
	@customer = Customer.new
	@customer.firstname = request["firstname"]
	@customer.lastname = request["lastname"]
	@customer.email = request["email"]
	@customer.password = request["password"]
	if @customer.save
		session["message"]="you have successfully signed Up and logged in\n welcome "+ @customer.firstname + " " + @customer.lastname 
		session["logged_in"] = true
		session["id"] = @customer.id
		session["firstname"] = @customer.firstname
		session["lastname"] = @customer.lastname
		session["email"] = @customer.email
		redirect to('/')
	else
		erb :customer_new
	end
end
get '/login' do 
	@username = ""
	@password = ""
	erb :login
end
get '/authenticate' do
	
	@username = request["email"] 
	@password = request["password"]
	user = Customer.where(:email =>@username,:password => @password).first
	if user
		session["message"]="welcome "+ user.firstname + " " + user.lastname 
		session["logged_in"] = true
		session["id"] = user.id
		session["firstname"] = user.firstname
		session["lastname"] = user.lastname
		session["email"] = user.email
		if user.orders.count !=0 and user.orders.where(:completed => 0).first
			session["current_order_id"] = user.orders.where(:completed => 0).first.id
		end
		redirect to('/')
	else
		@flash = "Invalid email/password combination"
		erb :login
		
	end
end
get '/logout' do
	session["message"]= "you have logged out"
	session["logged_in"] = false
	session["id"] = nil
	session["firstname"] = nil
	session["lastname"] = nil
	session["email"] = nil
	session["current_order_id"]= nil
	redirect to('/')
end
get '/market' do
	if session["logged_in"]
		require './models/product'
		@flash = session["message"]
		session["message"] =nil
		@products = Product.all.where(:status => 1)
		erb :market
	else 
		redirect to('/login')
	end
	
end
get '/everything.json' do
	@products = Product.all.where(:status => 1)
	json =@products.to_json(:include => {:order_lines => {:include => :order} })
	
end
get '/product/:id' do
	if session["logged_in"]
		
		@product = Product.find(params[:id])
		erb :product_single
	else 
		redirect to('/login')
	end
	
end
get '/order/:id' do
	if session["logged_in"]
		@flash = session["message"]
		session["message"] =nil
		@order = Order.find(params[:id])
		#@order.order_lines.count.inspect
		erb :order
	else 
		redirect to('/login')
	end
end
get '/orders' do
	if session["logged_in"]
		
		@orders = Order.where(:customer_id => session["id"]).all
		#session["id"].inspect
		#session["id"].inspect
		erb :orders
	else 
		redirect to('/login')
	end
end
get '/payment_done/:id' do
	if session["logged_in"]
		
		@order = Order.find(params[:id])
		@order.completed = true
		@order.save
		session["current_order_id"] = nil
		#@order.order_lines.count.inspect
		session['message'] = "Payment for Order #{@order.order_no} Completed"
		redirect to('/')
	else 
		redirect to('/login')
	end
end
post '/order' do
	 if session["logged_in"]
		@order = Order.new
		@order.customer_id = session["id"].to_i
		@order.total = request["price"].to_f * request["quantity"].to_f
		@order.order_no = "O"+Time.now.getutc.to_i.to_s
		@order_line = OrderLine.new
		@order_line.quantity = request["quantity"].to_i
		@order_line.unit_price = request["price"].to_f
		@order_line.total_price = request["price"].to_f * request["quantity"].to_f
		@order_line.product_id = request["product_id"].to_i
		@order_line.order_id = @order.id
		@order.order_lines << @order_line
		@order.save
		session["current_order_id"] =@order.id
		redirect to("/order/#{@order.id}")
		#erb :product_single
	else 
		redirect to('/login')
	end
end 
patch '/order/:id' do
	 if session["logged_in"]
		@order = Order.find(params[:id])
		@order.customer_id = session["id"].to_i
		@order.total = request["price"].to_f * request["quantity"].to_f
		@order.order_no = "O"+Time.now.getutc.to_i.to_s
		@order_line = @order.order_lines.where(:product_id => request["product_id"]).first
		if @order_line 
			@order_line.quantity = @order_line.quantity + request["quantity"].to_i
			@order_line.total_price =@order_line.total_price + request["price"].to_f * request["quantity"].to_f
			@order_line.save
		else 
			@order_line = OrderLine.new
			@order_line.quantity = request["quantity"].to_i
			@order_line.unit_price = request["price"].to_f
			@order_line.total_price = request["price"].to_f * request["quantity"].to_f
			@order_line.product_id = request["product_id"].to_i
			@order_line.order_id = @order.id
			@order.order_lines << @order_line
		end
		@order.save
		session["current_order_id"] =@order.id
		redirect to("/order/#{@order.id}")
		#erb :product_single
	else 
		redirect to('/login')
	end
end 

get '/orderline/delete/:id' do
	if session["logged_in"]
		
		@order_line = OrderLine.find(params[:id])
		erb :orderline_delete
	else 
		redirect to('/login')
	end
end
delete '/orderline/:id' do
	if session["logged_in"]
		
		@order_line = OrderLine.find(params[:id])
		if @order_line.destroy
			session["message"]="Product Deleted from the order"
			redirect to("/order/#{session["current_order_id"]}")
		else
			erb :orderline_delete
		end
	else 
		redirect to('/admin/login')
	end
	
end
#### admin login Routes ####

get '/admin' do 
	if session["admin_logged_in"]
		redirect to('/admin/products')
	else 
		redirect to('/admin/login')
	end
end

get '/admin/login' do 
	@username = ""
	@password = ""
	erb :admin_login
end
get '/admin/authenticate' do
	
	@username = request["email"] 
	@password = request["password"]
	user = AdminUser.where(:email =>@username,:password => @password).first
	if user
		session["message"]="welcome "+ user.firstname + " " + user.lastname 
		session["admin_logged_in"] = true
		session["admin_firstname"] = user.firstname
		session["admin_lastname"] = user.lastname
		session["admin_email"] = user.email
		redirect to('/admin')
	else
		@flash = "Invalid email/password combination"
		erb :admin_login
	end
end
get '/admin/logout' do
	session["message"]= "you have logged out"
	session["admin_logged_in"] = false
	session["admin_firstname"] = nil
	session["admin_lastname"] = nil
	session["admin_email"] = nil
	redirect to('/')
end
##### admin login Routes end ####

##### Products add/delete Routes via admin  ####
get '/admin/products' do
	if session["admin_logged_in"]
		
		@flash = session["message"]
		session["message"] =nil
		@products = Product.all
		erb :products
	else 
		redirect to('/admin/login')
	end
	
end
get '/admin/product' do
	if session["admin_logged_in"]
		
		@product = Product.new
		erb :product_new
	else 
		redirect to('/admin/login')
	end
end
post '/admin/product' do
	if session["admin_logged_in"]
		
		@product = Product.new
		@product.name = request["name"]
		@product.price = request["price"]
		@product.status = request["status"]
		@product.description = request["description"]
		if @product.save
			session["message"]="Product added"
			redirect to('/admin/products')
		else
			erb :product_new
		end
	else 
		redirect to('/admin/login')
	end
	
end
get '/admin/product/:id' do
	if session["admin_logged_in"]
		
		@product = Product.find(params[:id])
		erb :product_edit
	else 
		redirect to('/admin/login')
	end
end
patch '/admin/product/:id' do
	if session["admin_logged_in"]
		
		@product = Product.find(params[:id])
		@product.name = request["name"]
		@product.price = request["price"]
		@product.status = request["status"]
		@product.description = request["description"]
		if @product.save
			session["message"]="Product Updated"
			redirect to('admin/products')
		else
			erb :product_edit
		end
	else 
		redirect to('/admin/login')
	end
	
end
get '/admin/product/delete/:id' do
	if session["admin_logged_in"]
		
		@product = Product.find(params[:id])
		erb :product_delete
	else 
		redirect to('/admin/login')
	end
end
delete '/admin/product/:id' do
	if session["admin_logged_in"]
		
		@product = Product.find(params[:id])
		if @product.destroy
			session["message"]="Product Deleted"
			redirect to('/admin/products')
		else
			erb :product_edit
		end
	else 
		redirect to('/admin/login')
	end
	
end


