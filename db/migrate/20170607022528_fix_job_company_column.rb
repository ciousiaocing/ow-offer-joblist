class FixJobCompanyColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :jobs, :comany, :company
  end
end
