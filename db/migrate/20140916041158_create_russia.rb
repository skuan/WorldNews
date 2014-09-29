class CreateRussia < ActiveRecord::Migration
  def change
    create_table :russia do |t|
      t.string :headline
      t.string :summary
      t.string :url

      t.timestamps
    end
  end
end
