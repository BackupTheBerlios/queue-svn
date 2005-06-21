--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

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
