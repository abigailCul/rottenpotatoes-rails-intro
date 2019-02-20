class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session[:sort_by] = if params[:sort_by].present?
                        params[:sort_by]
                      else
                        session[:sort_by] || 'id'
                      end
  session[:rating] = if params[:rating].present?
                       params[:rating]
                     else
                       session[:rating] || { 'G' => '1', 'PG' => '1', 'PG-13' => '1', 'R' => '1' }
                     end

  if !(params[:sort_by].present? && params[:rating].present?)
    redirect_to movies_path(sort_by: session[:sort_by], rating: session[:rating])

    return
  end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
 private

  def check
    if params[:ratings]
      params[:ratings].keys
    else
      @all_ratings
    end
  end

end