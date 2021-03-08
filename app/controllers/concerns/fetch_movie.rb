module FetchMovie
  extend ActiveSupport::Concern

  included do

    private

    def set_movie
      @movie = Movie.find(params[:movie_id])
    end

  end
end
