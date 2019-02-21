class Movie < ActiveRecord::Base
    def self.all_ratings
      #  Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating}
      result = {}
  	  self.select(:rating).uniq.each do |movie|
  		result[movie.rating] = 1
	  end
  	  return result
    end
end
