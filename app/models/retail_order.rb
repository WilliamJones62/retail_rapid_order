class RetailOrder < ApplicationRecord
  has_many :retail_order_parts, inverse_of: :retail_order, :dependent => :destroy
  accepts_nested_attributes_for :retail_order_parts, reject_if: proc { |attributes| attributes['partdesc'].blank? }

  def self.get_orders
    all.each do |o|
      if o.status == "ACTIVE" && o.in_process == true && o.updated_at < 30.minutes.ago
        # order has been waiting for an order number for over 30 minutes
        o.in_process = false
        o.save
      end
    end
  end

end
