module Api
  module V1
    class RatingsController < ApplicationController
      include FetchMovie
      load_and_authorize_resource only: :update

      before_action :set_movie, only: %i[index create]

      def index
        @ratings = @movie.ratings.page(page).per(per_page)
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

    end
  end
end
