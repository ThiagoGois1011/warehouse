class Supplier < ApplicationRecord
  validates :corporate_name, :brand_name, :city, :state, :full_address, :restration_number, :email, presence: true
  has_many :product_models
end
