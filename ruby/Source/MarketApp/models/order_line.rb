class OrderLine < ActiveRecord::Base  
	
	belongs_to :order
	
	belongs_to :product

	validates :quantity, :presence => true, numericality:  { only_integer: true } 	

end  