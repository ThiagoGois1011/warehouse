class Warehouse < ApplicationRecord
  validates :name, :code, :description, :address, :CEP, :city, :area, presence: true
  validates :code, uniqueness: true
  validates :code, length: { is: 3 }
  has_many :stock_products
  def full_description
    "#{code} - #{name}"
  end
end


