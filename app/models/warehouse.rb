class Warehouse < ApplicationRecord
  validates :name, :code, :city, :area, presence: true
  validates :code, length: { is: 3 }
end
