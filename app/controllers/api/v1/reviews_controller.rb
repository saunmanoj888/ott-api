module Api
  module V1
    class ReviewsController < ApplicationController
      load_and_authorize_resource only: %i[update destroy]

      before_action :set_movie, only: %i[index create]

      def index
        @reviews = @movie.reviews.page(page).per(per_page)
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

      def destroy
        if @review.destroy
          json_response({ message: 'Review destroyed successfully' })
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

    end
  end
end
