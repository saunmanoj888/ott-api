class AddRatingsCountToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :ratings_count, :integer
  end
end
