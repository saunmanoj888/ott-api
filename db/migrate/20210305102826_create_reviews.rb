class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.text :body
      t.references :user
      t.references :movie

      t.timestamps
    end
  end
end
