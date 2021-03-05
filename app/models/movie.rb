class Movie < Video

  def ratings_sum
    ratings.pluck(:value).sum.to_f
  end
end
