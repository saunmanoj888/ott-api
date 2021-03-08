module Api
  module V1
    class ReviewsController < ApplicationController
      include FetchMovie
      load_and_authorize_resource only: :update

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

      private

      def review_params
        params.require(:review).permit(:body)
      end

    end
  end
end
