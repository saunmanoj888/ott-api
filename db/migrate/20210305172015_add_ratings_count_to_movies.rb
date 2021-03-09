class AddRatingsCountToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :ratings_count, :integer, default: 0
  end
end
