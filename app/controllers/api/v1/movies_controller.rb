module Api
  module V1
    class MoviesController < ApplicationController
      load_and_authorize_resource

      def index
        @movies = @movies.includes(:reviews, :ratings, :cast_crews).page(page).per(per_page)
        json_response(@movies)
      end

      def create
        if @movie.save
          json_response(@movie, :created)
        else
          json_response({ error: @movie.errors.full_messages }, :bad_request)
        end
      end

      def show
        json_response(@movie)
      end

      def update
        if @movie.update(movie_params)
          json_response(@movie)
        else
          json_response({ error: @movie.errors.full_messages }, :bad_request)
        end
      end

      def destroy
        if @movie.destroy
          json_response({ message: 'Movie destroyed successfully' })
        else
          json_response({ error: @movie.errors.full_messages }, :bad_request)
        end
      end

      private

      def movie_params
        params.require(:movie).permit(:title, :description, :release_date, :budget)
      end

    end
  end
end
