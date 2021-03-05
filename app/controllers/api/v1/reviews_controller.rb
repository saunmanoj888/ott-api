module Api
  module V1
    class ReviewsController < ApplicationController
      load_and_authorize_resource
      before_action :set_movie, only: %i[index create]
      before_action :set_review, only: %i[update]

      def index
        # Need to use pagination below
        @reviews = @movie.reviews
        json_response(@reviews)
      end

      def create
        @review = @movie.reviews.new(review_params.merge(user_id: current_user.id))
        if @review.save
          json_response(@review, :created)
        else
          json_response({ error: @review.errors.full_messages }, :bad_request)
        end
      end

      def update
        if @review.update(review_params)
          json_response(@review)
        else
          json_response({ error: @review.errors.full_messages }, :bad_request)
        end
      end

      private

      def review_params
        params.require(:review).permit(:body)
      end

      def set_movie
        @movie = Movie.find(params[:movie_id])
      end

      def set_review
        @rating = Review.find(params[:id])
      end

    end
  end
end
