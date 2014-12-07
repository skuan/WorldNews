class CreateIndia < ActiveRecord::Migration
  def change
    create_table :india do |t|
      t.string :headline
      t.text :description
      t.string :url
      t.text :body

      t.timestamps
    end
  end
end
