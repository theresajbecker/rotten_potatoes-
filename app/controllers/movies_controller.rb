class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
 
 end

  def index

    #Pulls Any Unique Value of Rating from Movie Database:
    @all_ratings = Movie.uniq.pluck(:rating)

    #Finds non-Nil Value for Field if it Exists from Current/Last Session:
    sort_field = params[:field] || session[:field]
    
    #Discovers Which Column to Hilight with CSS Code and
    #Saves Field from Current Session (params) to Session:
    session[:hilite] = params[:field] || session[:field]
    session[:field] = params[:field] || session[:field]

    #If Page Not Reset and Session Has a Direction then Flip Direction:
    if(params[:commit] != "Refresh")
        session[:direct] == :desc ? session[:direct] = :asc : session[:direct] = :desc 
    end

    #Put Direction (if it exists in session) In a Local Variable - Default Descending:
    sort_direct = session[:direct] || :desc

    #Opens a Temporary Hash to Solve Three Condition Scenario of:
    #    - params[:ratings] nil, session[:ratings] nil
#   #    - params[:ratings] nil, session[:ratings] has values
#   #    - params[:ratings] has values

    ratingsHash = {}
    ratingsHash[:ratings] = params[:ratings] || session[:ratings] || Hash[@all_ratings.map { |x| [x,x]}]
    ratingsHash[:ratings] ? sort_filter = ratingsHash[:ratings].keys : sort_filter = @all_ratings
    
    #Shoves Ratings into session[:ratings] to Keep Values:
    session[:ratings] = params[:ratings] || session[:ratings]

    #Checks for Missing params Values, Flips Direction, and redirects:
    if params[:commit] or params[:ratings] != ratingsHash[:ratings]
        session[:direct] == :desc ? session[:direct] = :asc : session[:direct] = :desc 
        redirect_to :field => session[:field], :ratings => ratingsHash[:ratings] and return
    end

    

    #Sorts Movies:
    @movies = Movie.order_by(sort_field, sort_direct, sort_filter)

    
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