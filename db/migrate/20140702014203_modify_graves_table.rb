class ModifyGravesTable < ActiveRecord::Migration
  def change
    rename_column :graves, :type, :grave_type
    remove_column :graves, :row, :integer
  end
end
