class Order < ActiveRecord::Base  
	belongs_to :customer
	has_many :order_lines
 	validates :order_no, :presence => true
 	validates :customer_id, :presence => true, numericality:  { only_integer: true }
 	validates :total, :presence => true, numericality: true 
    

end  