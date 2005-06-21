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
	Q_SIMPLE_CAMERA_BEHAVIOUR

inherit
	Q_CAMERA_BEHAVIOUR
	redefine
		process_mouse_moved,
		process_mouse_button_down,
		process_mouse_button_up
	end

feature -- camera
	rotation_distance : DOUBLE
	
	set_rotation_distance( distance_ : DOUBLE ) is
		do
			rotation_distance := distance_
		end
		
	
feature{NONE} -- event-handling
	zooming, rotating, moving : BOOLEAN
	last_x, last_y : DOUBLE

	process_mouse_moved( event_ : ESDL_MOUSEMOTION_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		local
			delta_x_, delta_y_ : DOUBLE
		do
			result := false
			if camera /= void then
				delta_x_ := x_ - last_x
				delta_y_ := y_ - last_y
			
				last_x := x_
				last_y := y_
			
				if zooming then
					camera.zoom( -delta_y_*rotation_distance )
					result := true
				elseif rotating then
					camera.rotate_around( 360*delta_x_, -180*delta_y_, rotation_distance )
					result := true
				elseif moving then
					camera.move( delta_x_ * rotation_distance, delta_y_ * rotation_distance )
				end
			end
		end
	
	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			last_x := x_
			last_y := y_
			
			rotating := false
			zooming := false
			moving := false

			if y_ >= 0.5 then
				rotating := true
			elseif x_ >= 0.5 then
				zooming := true
			else
				moving := true
			end

			result := rotating or zooming or moving
		end
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			if rotating or zooming or moving then
				rotating := false
				zooming := false
				moving := false
				
				result := true
			else
				result := false	
			end
		end
		

end -- class Q_SIMPLE_CAMERA_BEHAVIOUR
