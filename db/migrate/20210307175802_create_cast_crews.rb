class CreateCastCrews < ActiveRecord::Migration[6.1]
  def change
    create_table :cast_crews do |t|
      t.references :video
      t.references :person
      t.string     :designation
      t.string     :character

      t.timestamps
    end
  end
end
