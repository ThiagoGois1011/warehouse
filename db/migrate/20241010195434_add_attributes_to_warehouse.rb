class AddAttributesToWarehouse < ActiveRecord::Migration[7.2]
  def change
    add_column :warehouses, :address, :string
    add_column :warehouses, :CEP, :string
    add_column :warehouses, :description, :string
  end
end
