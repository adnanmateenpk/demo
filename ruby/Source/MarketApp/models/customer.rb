class Customer < ActiveRecord::Base  
	has_many :orders
 	
 	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
 	/[a-z0-9\\\/\#\@A-Z]{6,}+/
	validates :firstname, :presence => true
 	validates :lastname, :presence => true
 	validates :email, :presence => true,
                    :length => { :maximum => 100 },
                    :format => EMAIL_REGEX
    validates :password, :presence => true,
                    :length => { :minimum => 7 }

end  