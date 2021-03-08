class CreateCastCrews < ActiveRecord::Migration[6.1]
  def change
    create_table :cast_crews do |t|
      t.references :video
      t.references :person
      t.references :profession
      t.string     :character

      t.timestamps
    end
  end
end
