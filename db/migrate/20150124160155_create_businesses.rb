class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.integer :industry_id

      t.timestamps
      t.index :name
    end
  end
end
