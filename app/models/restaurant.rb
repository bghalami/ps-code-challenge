class Restaurant < ApplicationRecord
  validates_presence_of :name, :street_address, :post_code, :number_of_chairs
  
end
