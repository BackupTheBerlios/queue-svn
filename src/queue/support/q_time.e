indexing
	description: "Some methods to measure the time"
	author: "Benjamin Sigg"

class
	Q_TIME

feature
	last_time : INTEGER
	delta_time_millis : INTEGER

	restart is
		local
			time_ : INTEGER
		do
			time_ := current_time_millis
			
			delta_time_millis := time_ - last_time
			last_time := time_
		end
		
	current_time_millis : INTEGER is
		external
			"C [macro <ewg_esdl_function_c_glue_code.h>] :Uint32"
		alias
			"ewg_function_macro_SDL_GetTicks"
		end	
end -- class Q_TIME
