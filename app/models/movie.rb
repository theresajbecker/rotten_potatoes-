class Movie < ActiveRecord::Base

    def self.order_by field,direction,filter


        #Three Conditions:
        #    - Page First Starts, field == nil, All Movies Filtered by Check Boxes
#       #    - Sorts All Movies by Descending, Field Either "title" or "release_date"
#              Filtered by Check Boxes
#       #    - Sorts All Movies by Ascending, Field Either "title" or "release_date"
#       #      Filtered by Check Boxes
#
        if(field == nil)
            test_var = Movie.where("rating IN (?)", filter)

        elsif(direction == :desc)
            test_var = Movie.where("rating IN (?)", filter).order(field + " DESC")
 
        elsif (direction == :asc)
            test_var = Movie.where("rating IN (?)", filter).order(field + " ASC")

        end
        
        return test_var

    end

end