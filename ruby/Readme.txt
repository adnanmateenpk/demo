This is the Readme File


GEMS REQUIRED:
		'sinatra'
		'active_record'
		'mysql2'
		'json'
		'date'
		
Datbase File:
			Database configuration file for e-commerce app can be found in 'config/database.rb'. Configure the username,password, and database name for the database you imported from 'db_backup.sql' file
Start servers:
	through command line go to [app_folder]/Source/MarketApp and write  'ruby main.rb' to start web server for e-commerce website
	through command line go to [app_folder]/Source/PaymentGatewayApp and write  'ruby main.rb' to start web server for payment gateway dummy website
Links:
	http://localhost:1234/ -> ecommerce-app
	http://localhost:2345/ -> payment gateway dummy	(though you will not need to enter this manually )		

Main Page:
		you must login to place any orders or review your previous orders,  you wont be able to place your order unless you complete the payment for the previous order. you can edit the order by clicking the shopping cart link which will appear once you have added even a single product to the order 
		you can update the quantity by adding more products, to delete a product from the order you can click on the delete link which will take you to delete confirmation page if you want to delete you can press the delete button there to complete remove the product from the order
		
Payment Dummy:
		both the apps must be running for the payment to work. once you have been redirected to the payment gateway dummy you can give your name, card number, security code and the expiry date on your card. as required there is a 10% chance you will be redirected to the same page rejecting the card. if the card is accepted you will be redirected to the main website main page and a message will be shown confirming the payment of the order
		
Database DATA
		4 dummy products are added
		1 admin user (email : admin@admin.comp,password : adm1npa22word)
		1 customer(email : adnan@email.com,password : adnanmateen)
products and customers can be added but there is only one admin user

JSON:
a link for json http://localhost:1234/everything.json shows the products and the orders with those products in json format	
Admin Credentials and Admin Area:
		email : admin@admin.com
		password : adm1npa22word
		you can go to admin panel by click the admin area link in the main page of the application i.e. http://localhost:1234/ 
		or you can go to http://localhost:1234/admin, use the credentials and then you will be able to create/edit/delete products from the market
 
	 