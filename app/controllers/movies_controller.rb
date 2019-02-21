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
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    @checked_ratings = check
    @checked_ratings.each do |rating|
      params[rating] = true
    end

    @sort = params[:sort] || session[:sort] 
    session[:ratings] = session[:ratings] || {'G'=>'','PG'=>'','PG-13'=>'','R'=>''}
    @t_param = params[:ratings] || session[:ratings]
    session[:sort] = @sort
    session[:ratings] = @t_param 
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])

    if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:order].nil? && !session[:order].nil?)
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    elsif !params[:ratings].nil? || !params[:order].nil?
      if !params[:ratings].nil?
        array_ratings = params[:ratings].keys
        return @movies = Movie.where(rating: array_ratings).order(session[:order])
      else
        return @movies = Movie.all.order(session[:order])
      end
    elsif !session[:ratings].nil? || !session[:order].nil?
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    else
      return @movies = Movie.all
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