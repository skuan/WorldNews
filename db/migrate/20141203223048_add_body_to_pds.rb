class AddBodyToPds < ActiveRecord::Migration
  
  def change
  	add_column :pds, :body, :string
  end
  
end
