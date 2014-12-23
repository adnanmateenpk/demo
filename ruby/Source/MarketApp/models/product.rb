class Product < ActiveRecord::Base  
	has_many :order_lines
 	validates :name, :presence => true
 	validates :price, :presence => true, numericality: true
 	validates :status, :presence => true, numericality:  { only_integer: true }
    validates :description, :presence => true

end  