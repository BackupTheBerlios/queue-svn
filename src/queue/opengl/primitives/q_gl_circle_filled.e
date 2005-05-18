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
