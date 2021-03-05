class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.integer :value
      t.references :video
      t.references :user

      t.timestamps
    end
  end
end
