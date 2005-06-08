indexing
	description: "Objects that represent random number generators with advanced features"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_RANDOM
	
inherit
	DOUBLE_MATH
	
feature
	
	random_range(min:INTEGER; max:INTEGER): INTEGER is
			-- returns random number in the range [min..max]
		do
			if r_ = void then
				create r_.make
				r_.set_seed (current_time_millis)
			end
			Result := (r_.double_i_th (random_i)*(max-min)+min).rounded
			random_i := random_i+1
		ensure
			result >= min and result <= max
		end
		
	random_gaussian(m_: DOUBLE; s_:DOUBLE): DOUBLE is
			-- returns a random number with a gaussian density function with given mean and standard deviation
			-- uses the polar form of the box-muller transformation as seen on http://www.taygeta.com/random/boxmuller.html
		require
			m_ /= void
			s_ /= void
		local
			x1, x2,w,y1,y2 :DOUBLE
		do	
			if r_ = void then
				create r_.make
			end	
			from
				x1 := 2.0*r_.double_i_th(random_i)-1.0
				random_i := random_i+1
				x2 := 2.0*r_.double_i_th(random_i)-1.0
				random_i := random_i+1
				w := x1*x1 + x2*x2
			until
				w < 1.0
			loop
				x1 := 2.0*r_.double_i_th(random_i)-1.0
				random_i := random_i+1
				x2 := 2.0*r_.double_i_th(random_i)-1.0
				random_i := random_i+1
				w := x1*x1 + x2*x2
			end
			w := sqrt((-2.0*log(w)) / w);
			y1 := x1*w
			y2 := x2*w
			result := m_+y1*s_
		end
		
		
feature{NONE}
	random_i :INTEGER
	r_: RANDOM
	
	current_time_millis : INTEGER is
		external
			"C [macro <ewg_esdl_function_c_glue_code.h>] :Uint32"
		alias
			"ewg_function_macro_SDL_GetTicks"
		end	

end -- class Q_RANDOM
