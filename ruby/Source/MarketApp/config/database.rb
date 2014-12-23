require 'active_record'  
ActiveRecord::Base.establish_connection(  
    :adapter => "mysql2",  
    :host => "localhost",  
    :database => "ecom",  
    :username => "adnan_mateen",
    :password => "ec0mpa22"
)  