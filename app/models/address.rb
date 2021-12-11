class Address < ApplicationRecord
	validates :address_line_one, :city, :state, :country, presence: true
  validates :mobile_number, presence: true, numericality: true,
                length:  { minimum: 10, maximum: 13 }
	validates_numericality_of :pincode, only_integer: true, allow_blank: true                
	belongs_to :user
end
