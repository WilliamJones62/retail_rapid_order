class CreateRetailOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :retail_orders do |t|
      t.string :customer
      t.string :shipto
      t.date :date_required
      t.string :rep
      t.string :status
      t.string :cancel_rep
      t.date :cancel_date
      t.string :po_number
      t.text :notes
      t.boolean :order_entered
      t.boolean :second_run
      t.string :order_num
      t.boolean :in_process
      t.string :dp
      t.string :rep_name
      t.string :reject_reason
      t.string :cut_off

      t.timestamps
    end
  end
end
