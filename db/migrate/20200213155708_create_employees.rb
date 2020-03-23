class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.string :Badge_
      t.string :Firstname
      t.string :Lastname

      t.timestamps
    end
  end
end
