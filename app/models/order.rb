class Order < ActiveRecord::Base
  belongs_to :user
  has_one :charge
  has_many :line_items

  enum state: [:active, :paid]

  scope :paids, -> { where(state: 1) }

  def total_price
    line_items.inject(0) do |sum, line_item|
      sum + line_item.product.price
    end
  end
end
