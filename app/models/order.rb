class Order < ApplicationRecord
  belongs_to :warehouse
  belongs_to :supplier
  belongs_to :user
  enum :status,  { pending: 0 , delivered: 5, canceled: 9 }
  has_many :order_items
  has_many :product_models, through: :order_items
  validates :code, :estimated_delivery_date,  presence: true
  validate :estimated_delivery_date_is_future
  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def estimated_delivery_date_is_future
    if self.estimated_delivery_date.present? && self.estimated_delivery_date <= Date.today
      self.errors.add(:estimated_delivery_date, ' deve ser futura.')
    end
  end
end
