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
	description: "Objects that ..."

class
	BEN_TIME_TEST
inherit
	Q_TEST_CASE
	redefine
		default_create
	end
	
	Q_HUD_LABEL
	redefine
		default_create,
		draw
	end

create
	default_create

feature{NONE}
	default_create is
			-- 
		do
			make
			set_insets( create {Q_HUD_INSETS}.make( 0.1, 0.1, 0.1, 0.1 ))
		end
		

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
--			set_text( open_gl.current_time_millis.out )
			set_text( open_gl.time.delta_time_millis.out + " - " + open_gl.time.current_time.out )
			precursor( open_gl )
		end

	name : STRING is "Time"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is do
		result := void
	end
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		do
			
			set_bounds( 0.1, 0.1, 0.8, 0.3 )
			
			result := current
		end
		
	max_bound : Q_VECTOR_3D is do
		result := void
	end
		
	min_bound : Q_VECTOR_3D is do
		result := void
	end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
		end


end -- class BEN_TIME_TEST
