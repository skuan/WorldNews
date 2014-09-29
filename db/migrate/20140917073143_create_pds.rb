class CreatePds < ActiveRecord::Migration
  def change
    create_table :pds do |t|
      t.string :headline
      t.string :summary
      t.string :url

      t.timestamps
    end
  end
end
