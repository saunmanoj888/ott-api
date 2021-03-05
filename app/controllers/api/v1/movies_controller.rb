module Api
  module V1
    class MoviesController < ApplicationController
      load_and_authorize_resource
      before_action :set_movie, only: %i[show update destroy]

      def index
        # Need to use pagination below
        @movies = Movie.all.includes(:reviews, :ratings)
        json_response(@movies)
      end

      def create
        @movie = Movie.new(movie_params)
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

      def set_movie
        @movie = Movie.find(params[:id])
      end

    end
  end
end
