indexing
	description: "Objects that represent random number generators with advanced features"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_RANDOM
	
feature
	
	random_range(min:INTEGER; max:INTEGER): INTEGER is
			-- returns random number in the range [min..max]
		local 
			r_: RANDOM
		do
			create r_.make
			Result := (r_.double_i_th (random_i)*(max-min)+min).rounded
			random_i := random_i+1
		ensure
			result >= min and result <= max
		end
		
	random_gaussian(mean: DOUBLE; variance:DOUBLE): DOUBLE is
			-- returns a random number with a gaussian density function with given mean and variance
			-- uses the polar form of the box-muller transformation as seen on http://www.taygeta.com/random/boxmuller.html
		require
			mean /= void
			variance /= void
		local
			x1, x2,w,y1 :DOUBLE
			r_ : RANDOM
		do
			create r_.make
			from
				
			until
				w < 1.0
			loop
				x1 := 2.0*r_.double_i_th(random_i)-1.0
				x2 := 2.0*r_.double_i_th(random_i)-1.0
				w := x1*x1 + x2*x2
			end
			w := sqrt((-2.0*w.log) / w);
			y1 := x1*w
			y2 := x2*w
			result := m+y1*s
		end
		
		
feature{NONE}
	random_i :INTEGER

end -- class Q_RANDOM
