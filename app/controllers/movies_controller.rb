class MoviesController < ApplicationController
  
  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    session[:ratings] = params[:ratings].presence || session[:ratings].presence || @all_ratings
    session[:sort] = params[:sort].presence || session[:sort].presence || 'title'
    session[:direction] = params[:direction].presence || session[:direction].presence || 'asc'
    @movies = Movie.order(session[:sort] + " " + session[:direction]).where("rating IN (?)", session[:ratings])
  end


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
