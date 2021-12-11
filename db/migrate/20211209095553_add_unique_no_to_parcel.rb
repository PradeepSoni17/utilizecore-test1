class AddUniqueNoToParcel < ActiveRecord::Migration[6.1]
  def change
    add_column :parcels, :unique_no, :string
    add_index :parcels, :unique_no
  end
end
