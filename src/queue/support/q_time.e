indexing
	description: "Some methods to measure the time"
	author: "Benjamin Sigg"

class
	Q_TIME

feature
	current_time : INTEGER
	delta_time_millis : INTEGER

	restart is
		local
			time_ : INTEGER
		do
			time_ := current_time_millis
			
			delta_time_millis := time_ - current_time
			current_time := time_
		end

feature{NONE}
	current_time_millis : INTEGER is
		external
			"C [macro <ewg_esdl_function_c_glue_code.h>] :Uint32"
		alias
			"ewg_function_macro_SDL_GetTicks"
		end	
end -- class Q_TIME
