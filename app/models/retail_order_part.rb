class RetailOrderPart < ApplicationRecord
  belongs_to :retail_order, :foreign_key => "retail_order_id"
end
