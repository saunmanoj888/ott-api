class CreateVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.date :release_date
      t.bigint :budget
      t.string :type

      t.timestamps
    end
  end
end
