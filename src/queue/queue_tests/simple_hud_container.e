indexing
	description: "A container with a background color, but no spezial abilities"

class
	SIMPLE_HUD_CONTAINER

inherit
	Q_HUD_CONTAINER
	redefine
		draw
	end

creation
	make_color
	
feature
	make_color( red_, green_, blue_ : REAL ) is
		do
			make
			red := red_
			green := green_
			blue := blue_
		end
		
	draw( open_gl : Q_GL_DRAWABLE ) is
		do

			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			open_gl.gl.gl_color3f( red, green, blue )
			
			open_gl.gl.gl_vertex2d( x, y )
			open_gl.gl.gl_vertex2d( x, y+height )
			open_gl.gl.gl_vertex2d( x+width, y+height )
			open_gl.gl.gl_vertex2d( x+width, y )			
			
			open_gl.gl.gl_end
			
			precursor( open_gl )
		end
		

feature
	red, green, blue : REAL

end -- class SIMPLE_HUD_CONTAINER
