module Api
  module V1
    class RatingsController < ApplicationController
      load_and_authorize_resource
      before_action :set_movie, only: %i[index create]
      before_action :set_rating, only: %i[update]

      def index
        # Need to use pagination below
        @ratings = @movie.ratings
        json_response(@ratings)
      end

      def create
        @rating = @movie.ratings.new(rating_params.merge(user_id: current_user.id))
        if @rating.save
          json_response(@rating, :created)
        else
          json_response({ error: @rating.errors.full_messages }, :bad_request)
        end
      end

      def update
        if @rating.update(rating_params)
          json_response(@rating)
        else
          json_response({ error: @rating.errors.full_messages }, :bad_request)
        end
      end

      private

      def rating_params
        params.require(:rating).permit(:value)
      end

      def set_movie
        @movie = Movie.find(params[:movie_id])
      end

      def set_rating
        @rating = Rating.find(params[:id])
      end

    end
  end
end
