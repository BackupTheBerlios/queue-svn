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
	description: "Objects of this class draw a filled circle"
	author: "Andreas Kaegi"
	
class
	Q_GL_CIRCLE_FILLED

inherit
	Q_GL_OBJECT

	DOUBLE_MATH
		export
			{NONE} all
		end
create
	make

feature {NONE}-- create

	make (x_,y_: DOUBLE; radius_: DOUBLE; segments_count_: INTEGER) is
			-- Create object that draws a circle with center (x,y) and radius.
		require
			radius_ >= 0
			segments_count_ >= 3
		do
			x := x_
			y := y_
			radius := radius_
			segments_count := segments_count_
		end
		
		
feature -- interface

	draw (ogl: Q_GL_DRAWABLE) is
			-- Draws visualisation.
		local
			glf: GL_FUNCTIONS
			step: DOUBLE
			angle: DOUBLE
			dx, dy: DOUBLE
		do
			glf := ogl.gl
			
			glf.gl_begin (ogl.gl_constants.esdl_gl_triangle_fan)
			
			-- center vertex
			glf.gl_vertex2d (x, y)
			
			step := 2 * pi / segments_count
			
			from
				angle := 0
			until
				angle > 2 * pi
			loop
				dx := radius * cosine (angle)
				dy := radius * sine (angle)
				
				glf.gl_vertex2d (x + dx, y + dy)
				
				angle := angle + step
			end
			
			
			glf.gl_end
		end
		
	x, y: DOUBLE
	
	radius: DOUBLE
	
	segments_count: INTEGER

end -- class Q_GL_CIRCLE_FILLED
