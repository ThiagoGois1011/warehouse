class ProductModel < ApplicationRecord
  belongs_to :supplier
  validates :name, :sku, presence: true
  has_many :order_items
  has_many :orders, through: :order_items
end
